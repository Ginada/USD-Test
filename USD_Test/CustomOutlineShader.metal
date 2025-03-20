//
//  AngleTransparencyShader.metal
//  USD_Test
//
//  Created by Gina Adamova on 2025-03-16.
//

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

constexpr sampler textureSampler(address::clamp_to_edge, filter::linear);

[[visible]]
void customOutlineShader(realitykit::surface_parameters params)
{
    // Retrieve the base color tint from the material's constants.
    half3 baseTint = (half3)params.material_constants().base_color_tint();
    
    // Retrieve the base color and normal textures.
    auto baseColorTex = params.textures().base_color();
    auto baseNormal = params.textures().normal();
    
    // Get the texture coordinates and flip the y-axis if needed.
    float2 uv = params.geometry().uv0();
    uv.y = 1.0 - uv.y;
    
    // Sample the base color texture.
    half3 texColor = (half3)baseColorTex.sample(textureSampler, uv).rgb;
    // Sample the normal texture.
    half3 normalColor = (half3)baseNormal.sample(textureSampler, uv).rgb;
    
    // Compute the normal direction.
    // (Assumes the normal texture already encodes a normalized normal vector.)
    float3 normalDir = normalize(float3(normalColor));
    
    // Assume a fixed view direction.
    // For example, if the camera is nearly fixed looking along the negative Z-axis:
    float3 viewDirection = float3(0.0, 0.0, -1.0);
    
    // Compute the dot product between the normal and the view direction.
    float NdotV = max(dot(normalDir, viewDirection), 0.0);
    
    // Compute an alpha value so that surfaces facing the camera are more transparent.
    // Here, when NdotV is high (normal nearly aligned with view), alpha is low.
    float alpha = 1.0 - NdotV;
    // Apply a threshold to clamp the effect.
    alpha = (alpha > 0.8) ? 1.0 : 0.0;
    
    // Multiply the texture color by the base tint.
    half3 finalColor = texColor * baseTint;
    
    // Set the final base color on the output.
    params.surface().set_base_color(finalColor);
    
    // Retrieve metallic and roughness values.
    float metallic = params.material_constants().metallic_scale();
    float roughness = params.material_constants().roughness_scale();
    params.surface().set_metallic(metallic);
    params.surface().set_roughness(roughness);
    
    // Use the computed alpha for opacity.
    params.surface().set_opacity(alpha);
    
    // Pass the normal through.
    params.surface().set_normal(float3(normalColor));
}
