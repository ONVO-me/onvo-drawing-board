import { requireNativeModule } from 'expo-modules-core';

// Import the native module
const OnvoDrawingBoardModule = requireNativeModule('OnvoDrawingBoard');

// Export all functions
export const undoAction = async () => {
  try {
    await OnvoDrawingBoardModule.undoAction();
  } catch (error) {
    console.error('Error in undoAction:', error);
  }
};

export const redoAction = async () => {
  try {
    await OnvoDrawingBoardModule.redoAction();
  } catch (error) {
    console.error('Error in redoAction:', error);
  }
};

export const showDrafts = async () => {
  try {
    await OnvoDrawingBoardModule.showDrafts();
  } catch (error) {
    console.error('Error in showDrafts:', error);
  }
};

export const toggleToolPickerVisibility = async () => {
  try {
    await OnvoDrawingBoardModule.toggleToolPickerVisibility();
  } catch (error) {
    console.error('Error in toggleToolPickerVisibility:', error);
  }
};

export const wipeSavedDrawing = async () => {
  try {
    await OnvoDrawingBoardModule.wipeSavedDrawing();
  } catch (error) {
    console.error('Error in wipeSavedDrawing:', error);
  }
};

export const saveDrawingDraft = async () => {
  try {
    await OnvoDrawingBoardModule.saveDrawingDraft();
  } catch (error) {
    console.error('Error in saveDrawingDraft:', error);
  }
};

export const saveDrawing = async (uploadUrl) => {
  try {
    await OnvoDrawingBoardModule.saveDrawing(uploadUrl);
  } catch (error) {
    console.error('Error in saveDrawing:', error);
  }
};
