using Fmod5Sharp;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.RegularExpressions;

if (args.Length != 2)
    throw new ArgumentException("Usage: AudioRecovery AssetsDirectory ReportPath");
var root = Path.GetFullPath(args[0]);
var results = new List<object>();
var failures = 0;
foreach (var path in Directory.GetFiles(root, "*.fsb", SearchOption.AllDirectories))
{
    try
    {
        var raw = File.ReadAllBytes(path);
        if (!FsbLoader.TryLoadFsbFromByteArray(raw, out var bank) || bank == null)
            throw new InvalidDataException("Not a supported FSB bank");
        if (bank.Samples.Count != 1 ||
            !bank.Samples[0].RebuildAsStandardFileFormat(out var data, out var extension) ||
            data == null || extension == null)
            throw new InvalidDataException("Could not rebuild the single audio sample");
        var target = Path.ChangeExtension(path, extension.TrimStart('.'));
        if (File.Exists(target) || File.Exists(target + ".meta"))
            throw new IOException("Destination already exists: " + target);
        var meta = File.ReadAllText(path + ".meta");
        if (!meta.Contains("AudioImporter:"))
            throw new InvalidDataException("Expected the recovered AudioImporter metadata");
        var guid = Regex.Match(meta, @"(?m)^guid:\s*([0-9a-f]{32})$").Groups[1].Value;
        if (guid.Length != 32) throw new InvalidDataException("Missing asset GUID");
        // The build does not preserve the author's compression quality setting.
        // Use maximum quality when Unity recompresses the recovered audio.
        meta = new Regex(@"(?m)^(    quality:)\s*[^\r\n]+$").Replace(meta, "$1 1", 1);
        File.WriteAllBytes(target, data);
        File.WriteAllText(target + ".meta", meta);
        results.Add(new {
            source = Path.GetRelativePath(root, path),
            target = Path.GetRelativePath(root, target), guid,
            bankSha256 = Convert.ToHexString(SHA256.HashData(raw)).ToLowerInvariant(),
            audioSha256 = Convert.ToHexString(SHA256.HashData(data)).ToLowerInvariant(),
            bytes = data.Length, codec = bank.Header.AudioType.ToString(), success = true
        });
        File.Delete(path);
        File.Delete(path + ".meta");
    }
    catch (Exception ex)
    {
        failures++;
        results.Add(new { source = Path.GetRelativePath(root, path), success = false, error = ex.ToString() });
        Console.WriteLine("Failed: " + path + ": " + ex.Message);
    }
}
File.WriteAllText(args[1], JsonSerializer.Serialize(results, new JsonSerializerOptions { WriteIndented = true }));
Console.WriteLine($"Audio banks processed: {results.Count}; failures: {failures}");
return failures == 0 ? 0 : 1;
