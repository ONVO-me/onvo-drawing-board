// Reexport the native module. On web, it will be resolved to OnvoDrawingBoardModule.web.ts
// and on native platforms to OnvoDrawingBoardModule.ts
export { default } from './OnvoDrawingBoardView';
export * from './controler'; // Re-export all functions from controler.jsx
