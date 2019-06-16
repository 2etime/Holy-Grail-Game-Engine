import MetalKit

enum ClearColors {
    public static var Pink: MTLClearColor = MTLClearColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
    public static var Black: MTLClearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
}

class EngineSettings {
    public static var ClearColor: MTLClearColor = ClearColors.Black
    public static var MainPixelFormat: MTLPixelFormat = .bgra8Unorm_srgb
    public static var MainDepthPixelFormat: MTLPixelFormat = .depth32Float
    public static var SampleCount: Int = 2
    public static var StartingSceneType: SceneTypes = .Sandbox
}
