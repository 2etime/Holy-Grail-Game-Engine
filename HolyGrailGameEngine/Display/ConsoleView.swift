//
//  ConsoleView.swift
//  HolyGrailGameEngine
//
//  Created by Rick Twohy Jr on 6/17/19.
//  Copyright © 2019 Rick Twohy Jr. All rights reserved.
//

import MetalKit

class ConsoleView: MTKView {
    @IBOutlet weak var check_useBaseTexture: NSButton!
    @IBOutlet weak var check_useAmbientMap: NSButton!
    @IBOutlet weak var check_useNormalMap: NSButton!
    @IBOutlet weak var check_useSpecularMap: NSButton!
    
    @IBOutlet weak var slide_lightBrightness: NSSlider!
    @IBOutlet weak var slide_lightAmbientIntensity: NSSlider!
    @IBOutlet weak var slide_lightDiffuseIntensity: NSSlider!
    @IBOutlet weak var slide_lightSpecularIntensity: NSSlider!
    
    @IBOutlet weak var label_lightBrightness: NSTextField!
    @IBOutlet weak var label_lightAmbientIntensity: NSTextField!
    @IBOutlet weak var label_lightDiffuseIntensity: NSTextField!
    @IBOutlet weak var label_lightSpecularIntensity: NSTextField!
    
    @IBOutlet weak var color_lightColor: NSColorWell!
    
    @IBOutlet weak var color_materialAmbient: NSColorWell!
    @IBOutlet weak var color_materialDiffuse: NSColorWell!
    @IBOutlet weak var color_materialSpecular: NSColorWell!
    @IBOutlet weak var slider_materialShininess: NSSlider!
    
    @IBOutlet weak var label_materialAmbient: NSTextField!
    @IBOutlet weak var label_materialDiffuse: NSTextField!
    @IBOutlet weak var label_materialSpecular: NSTextField!
    @IBOutlet weak var label_materialShininess: NSTextField!
    
    
    
    @IBOutlet weak var slider_ambientMapIntensity: NSSlider!
    @IBOutlet weak var slider_specularMapIntensity: NSSlider!
    @IBOutlet weak var label_ambientMapIntensity: NSTextField!
    @IBOutlet weak var label_specularMapIntensity: NSTextField!
    
    @IBOutlet weak var check_showTriangle: NSButton!
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        reset()
    }
    
    func reset() {
        slide_lightBrightness.floatValue = Console.LightBrightness
        slide_lightAmbientIntensity.floatValue = Console.LightAmbientIntensity
        slide_lightDiffuseIntensity.floatValue = Console.LightDiffuseIntensity
        slide_lightSpecularIntensity.floatValue = Console.LightSpecularItensity
        
        label_lightBrightness.stringValue = getString(Console.LightBrightness)
        label_lightAmbientIntensity.stringValue = getString(Console.LightAmbientIntensity)
        label_lightDiffuseIntensity.stringValue = getString(Console.LightDiffuseIntensity)
        label_lightSpecularIntensity.stringValue = getString(Console.LightSpecularItensity)
        
        color_lightColor.color = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1)
        
        color_materialAmbient.color = NSColor(calibratedRed: CGFloat(Console.MaterialAmbient.x),
                                              green: CGFloat(Console.MaterialAmbient.y),
                                              blue: CGFloat(Console.MaterialAmbient.z),
                                              alpha: 1.0)
        label_materialAmbient.stringValue = getFloat3String(Console.MaterialAmbient)
        
        color_materialDiffuse.color = NSColor(calibratedRed: CGFloat(Console.MaterialDiffuse.x),
                                              green: CGFloat(Console.MaterialDiffuse.y),
                                              blue: CGFloat(Console.MaterialDiffuse.z),
                                              alpha: 1.0)
        label_materialDiffuse.stringValue = getFloat3String(Console.MaterialDiffuse)
        
        color_materialSpecular.color = NSColor(calibratedRed: CGFloat(Console.MaterialSpecular.x),
                                               green: CGFloat(Console.MaterialSpecular.y),
                                               blue: CGFloat(Console.MaterialSpecular.z),
                                               alpha: 1.0)
        
        slider_materialShininess.floatValue = Console.MaterialShininess
        label_materialSpecular.stringValue = getFloat3String(Console.MaterialSpecular)
        label_materialShininess.stringValue = String(format: "%.1f", Console.MaterialShininess)
        label_ambientMapIntensity.stringValue = String(format: "%.1f", Console.MaterialAmbientMapIntensity)
        label_specularMapIntensity.stringValue = String(format: "%.1f", Console.MaterialSpecularMapIntensity)
    }
    
    func getString(_ val: Float)->String {
        return String(format: "%.1f", val)
    }
    
    func getFloat3String(_ val: float3)->String {
        return "(\(String(format: "%.1f", val.x)),\(String(format: "%.1f", val.y)), \(String(format: "%.1f", val.z)))"
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if(Console.ShouldReset){
            reset()
            Console.ShouldReset = false
        }
    }
    
    // ############# TEXTURE MAP CHECKBOXES ############################
    @IBAction func check_baseTextureUpdate(_ sender: NSButton) {
        Console.UseBaseTexture = !Console.UseBaseTexture
    }
    
    @IBAction func check_ambientMapUpdate(_ sender: NSButton) {
        Console.UseAmbientMap = !Console.UseAmbientMap
    }
    
    @IBAction func check_normalMapUpdate(_ sender: NSButton) {
        Console.UseNormalMap = !Console.UseNormalMap
    }
    
    @IBAction func check_specularMapUpdate(_ sender: NSButton) {
        Console.UseSpecularMap = !Console.UseSpecularMap
    }
    
    @IBAction func check_showTriangles(_ sender: NSButton) {
        Console.ShowTriangles = !Console.ShowTriangles
    }
    
    // ############# LIGHT VALUES ############################
    @IBAction func slider_updateLightBrightness(_ sender: NSSlider) {
        let value = sender.floatValue
        let stringValue = getString(value)
        label_lightBrightness.stringValue = stringValue
        Console.LightBrightness = value
    }
    
    @IBAction func slider_updateAmbientIntensity(_ sender: NSSlider) {
        let value = sender.floatValue
        let stringValue = getString(value)
        label_lightAmbientIntensity.stringValue = stringValue
        Console.LightAmbientIntensity = value
    }
    
    @IBAction func slider_updateDiffuseIntensity(_ sender: NSSlider) {
        let value = sender.floatValue
        let stringValue = getString(value)
        label_lightDiffuseIntensity.stringValue = stringValue
        Console.LightDiffuseIntensity = value
    }
    
    @IBAction func slider_updateSpecularIntensity(_ sender: NSSlider) {
        let value = sender.floatValue
        let stringValue = getString(value)
        label_lightSpecularIntensity.stringValue = stringValue
        Console.LightSpecularItensity = value
    }
    
    @IBAction func color_updateLightColor(_ sender: NSColorWell) {
        let color = float3(Float(sender.color.redComponent), Float(sender.color.greenComponent), Float(sender.color.blueComponent))
        Console.LightColor = color
    }
    
    @IBAction func color_materialAmbientUpdate(_ sender: NSColorWell) {
        let values = float3(Float(sender.color.redComponent), Float(sender.color.greenComponent), Float(sender.color.blueComponent))
        let stringValue = getFloat3String(values)
        label_materialAmbient.stringValue = stringValue
        Console.MaterialAmbient = values
    }
    
    @IBAction func color_materialDiffuseUpdate(_ sender: NSColorWell) {
        let values = float3(Float(sender.color.redComponent), Float(sender.color.greenComponent), Float(sender.color.blueComponent))
        let stringValue = getFloat3String(values)
        label_materialDiffuse.stringValue = stringValue
        Console.MaterialDiffuse = values
    }
    
    @IBAction func color_materialSpecularUpdate(_ sender: NSColorWell) {
        let values = float3(Float(sender.color.redComponent), Float(sender.color.greenComponent), Float(sender.color.blueComponent))
        let stringValue = getFloat3String(values)
        label_materialSpecular.stringValue = stringValue
        Console.MaterialSpecular = values
    }
    
    @IBAction func slider_updateMaterialShininess(_ sender: NSSlider) {
        let value = sender.floatValue
        let stringValue = getString(value)
        label_materialShininess.stringValue = stringValue
        Console.MaterialShininess = value
    }
    
    @IBAction func slider_updateAmbientMapIntensity(_ sender: NSSlider) {
        let value = sender.floatValue
        let stringValue = getString(value)
        label_ambientMapIntensity.stringValue = stringValue
        Console.MaterialAmbientMapIntensity = value
    }
    
    @IBAction func slider_updateSpecularMapIntensity(_ sender: NSSlider) {
        let value = sender.floatValue
        let stringValue = getString(value)
        label_specularMapIntensity.stringValue = stringValue
        Console.MaterialSpecularMapIntensity = value
    }
    
}

class Console {
    public static var UseBaseTexture: Bool = false
    public static var UseAmbientMap: Bool = false
    public static var UseNormalMap: Bool = false
    public static var UseSpecularMap: Bool = false
    
    public static var LightBrightness: Float = 1.0
    public static var LightAmbientIntensity: Float = 1.0
    public static var LightDiffuseIntensity: Float = 1.0
    public static var LightSpecularItensity: Float = 1.0
    
    public static var LightColor: float3 = float3(1,1,1)
    
    public static var MaterialAmbient: float3 = float3(0.03, 0.03, 0.03)
    public static var MaterialDiffuse: float3 = float3(0.6, 0.6, 0.6)
    public static var MaterialSpecular: float3 = float3(1, 1, 1)
    public static var MaterialShininess: Float = 50.0
    
    public static var MaterialAmbientMapIntensity: Float = 1.0
    public static var MaterialSpecularMapIntensity: Float = 1.0
    
    public static var ShouldReset: Bool = true
    
    public static var ShowTriangles: Bool = false
}
