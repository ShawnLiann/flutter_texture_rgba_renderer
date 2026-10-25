//
//  TextureRgbaApi.m
//  texture_rgba_renderer
//
//  Created by kingtous on 2023/2/19.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import "texture_rgba_renderer/texture_rgba_renderer-Swift.h"

#if __cplusplus
extern "C" {
#endif
    
/// Keep the same name with Windows.
void FlutterRgbaRendererPluginOnRgba(void* texture_rgba_ptr, const uint8_t* buffer, int len, int width, int height, int stride_align) {
    TextRgba* texture_rgba = (__bridge TextRgba *)(texture_rgba_ptr);
    [texture_rgba markFrameAvaliableRawWithBuffer:buffer len:len width:width height:height stride_align: stride_align];
}

/// Zero-copy entry point: hand a decoded CVPixelBuffer over without a copy.
///
/// `pixel_buffer` is borrowed and only valid during this call; the receiver
/// takes its own reference when it keeps the frame. Returns 1 when the frame
/// was taken over and will be presented, 0 when it was refused - the caller
/// must then deliver the same decoded frame through the RGBA path.
int32_t FlutterRgbaRendererPluginOnPixelBuffer(void* texture_rgba_ptr, void* pixel_buffer, int32_t width, int32_t height, uint32_t pixfmt) {
    if (texture_rgba_ptr == NULL || pixel_buffer == NULL) {
        return 0;
    }
    TextRgba* texture_rgba = (__bridge TextRgba *)(texture_rgba_ptr);
    BOOL accepted = [texture_rgba markFrameAvailableWithPixelBuffer:(CVPixelBufferRef)pixel_buffer
                                                              width:width
                                                             height:height
                                                             pixfmt:pixfmt];
    return accepted ? 1 : 0;
}

#if __cplusplus
} //Extern C
#endif
