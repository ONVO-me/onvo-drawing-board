import * as React from 'react';

import { OnvoDrawingBoardViewProps } from './OnvoDrawingBoard.types';

export default function OnvoDrawingBoardView(props: OnvoDrawingBoardViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
