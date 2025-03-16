//
//  CustomMakeupShader.metal
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-15.
//


#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

constexpr sampler textureSampler(address::clamp_to_edge, filter::linear);

[[visible]]
void customMakeupShader(realitykit::surface_parameters params)
{
    // Retrieve the base color tint from the material's constants.
    half3 baseTint = (half3)params.material_constants().base_color_tint();
    
    // Retrieve the base color and normal textures.
    auto baseColorTex = params.textures().base_color();
    auto baseNormal = params.textures().normal();
    auto opacityTex = params.textures().emissive_color();
    
    // Retrieve a custom texture (e.g., opacity texture) if needed.
    
    // Get the texture coordinates and flip the y-axis (if needed).
    float2 uv = params.geometry().uv0();
    uv.y = 1.0 - uv.y;
    
    // Sample the base color texture.
    half3 texColor = (half3)baseColorTex.sample(textureSampler, uv).rgb;
    
    half3 normalColor = (half3)baseNormal.sample(textureSampler, uv).rgb;
    float opacityScale = params.material_constants().opacity_scale();
    half opacity = (half)opacityTex.sample(textureSampler, uv).r * opacityScale;
    
    // Optionally, sample the opacity texture.
    // For example, if your opacity texture is single channel, you might do:
    
    
    // Multiply the texture color by the tint.
    half3 finalColor = texColor * baseTint;
    
    // Set the final base color on the output.
    params.surface().set_base_color(finalColor);
    
    // Retrieve metallic and roughness from the material constants and pass them through.
    float metallic = params.material_constants().metallic_scale();
    float roughness = params.material_constants().roughness_scale();
   
    float computedRoughness = roughness + (1 - opacity);
    params.surface().set_metallic(metallic);
    params.surface().set_roughness(computedRoughness);
    params.surface().set_opacity(opacity);
    params.surface().set_normal(float3(normalColor));
}
