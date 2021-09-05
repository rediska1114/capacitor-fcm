declare global {
  interface PluginRegistry {
    CapacitorFCM: CapacitorFCMPlugin;
  }
}

export interface ISubscribeToOptions {
  topic: string;
}

export interface IUnsubscribeFromOptions {
  topic: string;
}

export interface ISetAutoInitOptions {
  enabled: boolean;
}
export interface IGetTokenResult {
  token: string;
}

export interface IIsAutoInitEnabledResult {
  enabled: boolean;
}
export interface CapacitorFCMPlugin {
  subscribeTo(options: ISubscribeToOptions): Promise<void>;
  unsubscribeFrom(options: IUnsubscribeFromOptions): Promise<void>;
  getToken(): Promise<IGetTokenResult>;
  deleteInstance(): Promise<void>;
  setAutoInit(options: ISetAutoInitOptions): Promise<void>;
  isAutoInitEnabled(): Promise<IIsAutoInitEnabledResult>;
}
