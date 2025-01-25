import React from 'react';
import { requireNativeViewManager } from 'expo-modules-core';
import { StyleProp, ViewStyle } from 'react-native';

type OnvoDrawingBoardViewProps = {
  style?: StyleProp<ViewStyle>;
  qualityControl?: number;
  onDismiss?: () => void;
};

const NativeView = requireNativeViewManager('OnvoDrawingBoard');

const OnvoDrawingBoardView: React.FC<OnvoDrawingBoardViewProps> = (props) => {
  const { style, qualityControl = 0.75, onDismiss } = props;

  return (
    <NativeView
      style={style}
      qualityControl={qualityControl}
      onDismiss={onDismiss}
    />
  );
};

export default OnvoDrawingBoardView; // Ensure this is the default export