import { NativeModule, requireNativeModule } from 'expo';

import { OnvoDrawingBoardModuleEvents } from './OnvoDrawingBoard.types';

declare class OnvoDrawingBoardModule extends NativeModule<OnvoDrawingBoardModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<OnvoDrawingBoardModule>('OnvoDrawingBoard');
