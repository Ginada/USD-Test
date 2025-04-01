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
    // Consolidate constant structures into local variables.
    auto mc = params.material_constants();
    auto tx = params.textures();
    
    // Retrieve values from the consolidated constants.
    half3 baseTint = (half3)mc.base_color_tint();
    auto baseColorTex = tx.base_color();
    auto baseNormal = tx.normal();
    auto opacityTex = tx.emissive_color();
    
    // Get and modify the texture coordinates.
    float2 uv = params.geometry().uv0();
    uv.y = 1.0 - uv.y;
    
    // Sample textures.
    half3 texColor = (half3)baseColorTex.sample(textureSampler, uv).rgb;
    half3 normalColor = (half3)baseNormal.sample(textureSampler, uv).rgb;
    
    float opacityScale = mc.opacity_scale();
    half opacity = (half)opacityTex.sample(textureSampler, uv).r * opacityScale;
    
    // Calculate final color.
    half3 finalColor = texColor * baseTint;
    params.surface().set_base_color(finalColor);
    
    // Retrieve metallic and roughness and compute new roughness.
    float metallic = mc.metallic_scale();
    float roughness = mc.roughness_scale();
    float computedRoughness = roughness + (1 - opacity);
    if (opacity < 0.01)
    {
        computedRoughness = 1.0;
                metallic = 0.0;
        normalColor = half3(0.5, 0.5, 0.5); // purple
    }
    computedRoughness = clamp(computedRoughness, 0.0, 1.0);
    params.surface().set_emissive_color(half3(0.0, 0.0, 0.0));
    params.surface().set_specular(0);
    params.surface().set_clearcoat(0);
    params.surface().set_clearcoat_roughness(0);
    params.surface().set_metallic(metallic);
    params.surface().set_roughness(computedRoughness);
    params.surface().set_opacity(opacity);
    params.surface().set_normal(float3(normalColor));
}
