using AssetRipper.Import.Logging;
using AssetRipper.Export.UnityProjects;
using AssetRipper.Export.UnityProjects.Configuration;
using AssetRipper.Export.UnityProjects.Shaders;
using AssetRipper.Import.Configuration;
using AssetRipper.IO.Files;
using AssetRipper.SourceGenerated.Classes.ClassID_48;
using System.Text.Json;

if (args.Length != 2) throw new ArgumentException("Usage: ShaderRecovery installation output");
Logger.Add(new ConsoleLogger());
Logger.AllowVerbose = false;
Directory.CreateDirectory(args[1]);
var settings = new LibraryConfiguration();
settings.ImportSettings.ScriptContentLevel = ScriptContentLevel.Level0;
settings.ImportSettings.IgnoreStreamingAssets = false;
var data = new ExportHandler(settings).Load(new[] { Path.GetFullPath(args[0]) });
Console.WriteLine($"Loaded Unity {data.ProjectVersion}");
var reports = new List<object>();
var i = 0;
foreach (var shader in data.GameBundle.FetchAssets().OfType<IShader>())
{
    var name = shader.ParsedForm.Name.String;
    if (!(name.StartsWith("Reptile/") || name.StartsWith("Shader Forge/") || name.StartsWith("Custom/") || name.StartsWith("Easy Decal/") || name.StartsWith("Graphy/") || name.StartsWith("Unlit/") || name == "Standard Triplanar")) continue;
    var stem = Path.Combine(args[1], $"{i++:D5}");
    var success = false;
    string? error = null;
    try
    {
        new ShaderDisassemblyExporter().Export(null!, shader, stem + ".disassembly.txt", LocalFileSystem.Instance);
        success = new USCShaderExporter().Export(null!, shader, stem + ".shader", LocalFileSystem.Instance);
    }
    catch (Exception ex) { error = ex.ToString(); }
    reports.Add(new { name, source = shader.Collection.Name, shader.PathID, file = Path.GetFileName(stem), success, error });
    Console.WriteLine($"{i}: {name}; decompiled={success}");

}
File.WriteAllText(Path.Combine(args[1], "shader-index.json"), JsonSerializer.Serialize(reports, new JsonSerializerOptions { WriteIndented = true }));
