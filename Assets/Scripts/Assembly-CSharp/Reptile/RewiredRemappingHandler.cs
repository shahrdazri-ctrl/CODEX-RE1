using System.Collections.Generic;
using Rewired;

namespace Reptile
{
	public class RewiredRemappingHandler
	{
		private RewiredControllerHandler rewiredControllerHandler;

		private ControllerPollingInfo lastPolledControllerInfo;

		public ControllerPollingInfo LastPolledControllerInfo => lastPolledControllerInfo;

		public RewiredRemappingHandler(RewiredControllerHandler rewiredControllerHandler)
		{
			this.rewiredControllerHandler = rewiredControllerHandler;
		}

		public bool AttemptElementReassignment(Controller controller, ControllerPollingInfo info, int actionId, int controllerMapCategoryId, ActionElementMap actionElementMapToUpdate, out ActionElementMap updatedActionElementMap)
		{
			updatedActionElementMap = null;
			if (controller == null || actionElementMapToUpdate == null)
			{
				return false;
			}
			rewiredControllerHandler.GetPlayerControllerHelper();
			ControllerMap controllerMap = rewiredControllerHandler.GetControllerMap(controllerMapCategoryId, controller);
			if (controllerMap == null)
			{
				return false;
			}
			ElementAssignment elementAssignment = RewiredStructUtility.CreateElementReassignmentFromPollingInfo(controller.type, info, actionId, actionElementMapToUpdate.id);
			return controllerMap.ReplaceOrCreateElementMap(elementAssignment, out updatedActionElementMap);
		}

		public bool AttemptNewElementAssignment(Controller controller, ControllerPollingInfo info, int actionId, int controllerMapCategoryId, out ActionElementMap newActionElementMap)
		{
			newActionElementMap = null;
			if (controller == null)
			{
				return false;
			}
			rewiredControllerHandler.GetPlayerControllerHelper();
			ControllerMap controllerMap = rewiredControllerHandler.GetControllerMap(controllerMapCategoryId, controller);
			if (controllerMap == null)
			{
				return false;
			}
			ElementAssignment elementAssignment = RewiredStructUtility.CreateNewElementAssignmentFromPollingInfo(controller.type, info, actionId);
			return controllerMap.ReplaceOrCreateElementMap(elementAssignment, out newActionElementMap);
		}

		public bool DetectConflictInMapping(Controller controller, ActionElementMap actionElementMap, int playerId = 0)
		{
			Rewired.Player.ControllerHelper playerControllerHelper = rewiredControllerHandler.GetPlayerControllerHelper();
			ElementAssignmentConflictCheck conflictCheck = RewiredStructUtility.CreateElementAssignmentConflictCheck(controller, actionElementMap, playerId);
			return playerControllerHelper.conflictChecking.DoesElementAssignmentConflict(conflictCheck, skipDisabledMaps: false);
		}

		public void RetrieveConflictingActionIds(Controller controller, int controllerMapCategoryId, List<int> actionIds, int playerId = 0)
		{
			if (controller == null)
			{
				return;
			}
			actionIds.Clear();
			Rewired.Player rewiredPlayerByPlayerId = RewiredUtility.GetRewiredPlayerByPlayerId(playerId);
			ControllerMap controllerMap = rewiredControllerHandler.GetControllerMap(controllerMapCategoryId, controller, playerId);
			foreach (ElementAssignmentConflictInfo item in rewiredPlayerByPlayerId.controllers.conflictChecking.ElementAssignmentConflicts(controller.type, controller.id, controllerMap))
			{
				if (!actionIds.Contains(item.actionId))
				{
					actionIds.Add(item.actionId);
				}
			}
		}

		public bool DetectPollForButton(Controller controller, out ControllerPollingInfo info)
		{
			info = default(ControllerPollingInfo);
			if (controller == null)
			{
				return false;
			}
			Rewired.Player.ControllerHelper playerControllerHelper = rewiredControllerHandler.GetPlayerControllerHelper();
			if (controller.type == ControllerType.Mouse)
			{
				info = playerControllerHelper.polling.PollControllerForFirstButtonDown(controller.type, controller.id);
			}
			else if (controller.type == ControllerType.Keyboard || controller.type == ControllerType.Joystick)
			{
				info = playerControllerHelper.polling.PollControllerForFirstElementDown(controller.type, controller.id);
			}
			if (info.success)
			{
				return HandleSuccessFullPollingForButton(info, controller);
			}
			return false;
		}

		private bool HandleSuccessFullPollingForButton(ControllerPollingInfo info, Controller pollingForController)
		{
			if (pollingForController == null)
			{
				return false;
			}
			if (info.controllerId != pollingForController.id)
			{
				return false;
			}
			if (info.controllerType == ControllerType.Joystick && pollingForController.type == ControllerType.Joystick)
			{
				return true;
			}
			if ((info.controllerType == ControllerType.Keyboard || info.controllerType == ControllerType.Mouse) && (pollingForController.type == ControllerType.Keyboard || pollingForController.type == ControllerType.Mouse))
			{
				return true;
			}
			return false;
		}
	}
}
