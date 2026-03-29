import { CapacitorConfig } from '@capacitor/cli'

const isProduction = process.env.CAPACITOR_ENV === 'production' || process.env.NODE_ENV === 'production'

const config: CapacitorConfig = {
  appId: 'com.sentinel.app',
  appName: 'SENTINEL',
  webDir: '../../DasiaAIO-Frontend/app-dist',
  server: {
    androidScheme: isProduction ? 'https' : 'http',
    cleartext: !isProduction,
  },
  android: {
    allowMixedContent: !isProduction,
    captureInput: true,
    webContentsDebuggingEnabled: !isProduction,
  },
  plugins: {
    SplashScreen: {
      launchAutoHide: true,
      backgroundColor: '#0b1220',
    },
    StatusBar: {
      overlaysWebView: true,
      style: 'DARK',
      backgroundColor: '#0b1220',
    },
  },
}

export default config
