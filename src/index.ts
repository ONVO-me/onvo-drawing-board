// Reexport the native module. On web, it will be resolved to OnvoDrawingBoardModule.web.ts
// and on native platforms to OnvoDrawingBoardModule.ts
export { default } from './OnvoDrawingBoardModule';
export { default as OnvoDrawingBoardView } from './OnvoDrawingBoardView';
export * from  './OnvoDrawingBoard.types';
