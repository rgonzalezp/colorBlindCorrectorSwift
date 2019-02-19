struct RGBAPixel {
    public init (rawVal : UInt32) {
        raw = rawVal
    }
    public var raw: UInt32
    public var red: UInt8 {
        get { return UInt8(raw & 0xFF)}
        set{ raw = UInt32(newValue << 24) | (raw & 0xFFFFFF00)}
    }
    public var green: UInt8 {
        get {   return UInt8((raw & 0xFF00) >> 8)}
        set{ raw = UInt32(newValue << 24) | (raw & 0xFFFF00FF)}
    }
    public var blue: UInt8 {
        get { return UInt8((raw & 0xFF0000) >> 16)}
        set{ raw = UInt32(newValue << 24) | (raw & 0xFF00FFFF)}
    }
    public var alpha: UInt8 {
        get { return UInt8((raw & 0xFF000000) >> 24)}
        set{ raw = UInt32(newValue << 24) | (raw & 0x00FFFFFF)}
    }
    
    public mutating func change (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red   = UInt32(red)
        let green = UInt32(green)
        let blue  = UInt32(blue)
        let alpha = UInt32(alpha)
        raw = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }
}
        
