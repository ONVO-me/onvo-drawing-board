import { requireNativeView } from 'expo';
import * as React from 'react';

import { OnvoDrawingBoardViewProps } from './OnvoDrawingBoard.types';

const NativeView: React.ComponentType<OnvoDrawingBoardViewProps> =
  requireNativeView('OnvoDrawingBoard');

export default function OnvoDrawingBoardView(props: OnvoDrawingBoardViewProps) {
  return <NativeView {...props} />;
}
