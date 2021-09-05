import { CapacitorFCMPlugin } from './definitions';
import { Plugins } from '@capacitor/core';

const CapacitorFCM = Plugins.CapacitorFCM as CapacitorFCMPlugin;

export class FCM {
  private fcm = CapacitorFCM;

  subscribeTo(topic: string) {
    return this.fcm.subscribeTo({ topic });
  }
  unsubscribeFrom(topic: string) {
    return this.fcm.unsubscribeFrom({ topic });
  }
  setAutoInit(enabled: boolean) {
    this.fcm.setAutoInit({ enabled });
  }

  deleteInstance = this.fcm.deleteInstance;
  getToken = this.fcm.getToken();
  isAutoInitEnabled = this.fcm.isAutoInitEnabled;
}
