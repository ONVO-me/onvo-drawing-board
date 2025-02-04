import React, { useEffect } from 'react';
import { Alert, SafeAreaView, StyleSheet } from 'react-native';
import OnvoDrawingBoardView, { undoAction } from 'onvo-drawing-board';

export default function App() {
  useEffect(() => {
    undoAction()
  }, [])
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