import React from 'react';
import { SafeAreaView, StyleSheet } from 'react-native';
import OnvoDrawingBoardView from 'onvo-drawing-board'; // Import the component

export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <OnvoDrawingBoardView 
      style={{flex:1}}
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