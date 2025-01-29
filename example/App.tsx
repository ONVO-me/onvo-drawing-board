import React, { useEffect } from 'react';
import { Alert, SafeAreaView, StyleSheet } from 'react-native';
import OnvoDrawingBoardView,{saveDrawing, toggleToolPickerVisibility} from 'onvo-drawing-board';

export default function App() {
  useEffect(() => {
    const func = async () => {
     const response = await saveDrawing('https://cdn.onvo.me/api/ios/','da')
     Alert.alert('tecccst',response)
    }
    func()
  },[])
  return (
    <SafeAreaView style={styles.container}>
      <OnvoDrawingBoardView
        style={{ flex: 1 }}
        qualityControl={0.75}
        onDismiss={() => console.log('Drawing view dismissed')}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
});