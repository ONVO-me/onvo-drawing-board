import { registerWebModule, NativeModule } from 'expo';

import { OnvoDrawingBoardModuleEvents } from './OnvoDrawingBoard.types';

class OnvoDrawingBoardModule extends NativeModule<OnvoDrawingBoardModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(OnvoDrawingBoardModule);
