Shader "FX/Water4" { 
Properties {
	_ReflectionTex ("Internal reflection", 2D) = "white" {}
	
	_MainTex ("Fallback texture", 2D) = "black" {}	
	_ShoreTex ("Shore & Foam texture ", 2D) = "black" {}	
	_BumpMap ("Normals ", 2D) = "bump" {}
				
	_DistortParams ("Distortions (Bump waves, Reflection, Fresnel power, Fresnel bias)", Vector) = (1.0 ,1.0, 2.0, 1.15)
	_InvFadeParemeter ("Auto blend parameter (Edge, Shore, Distance scale)", Vector) = (0.15 ,0.15, 0.5, 1.0)
	
	_AnimationTiling ("Animation Tiling (Displacement)", Vector) = (2.2 ,2.2, -1.1, -1.1)
	_AnimationDirection ("Animation Direction (displacement)", Vector) = (1.0 ,1.0, 1.0, 1.0)

	_BumpTiling ("Bump Tiling", Vector) = (1.0 ,1.0, -2.0, 3.0)
	_BumpDirection ("Bump Direction & Speed", Vector) = (1.0 ,1.0, -1.0, 1.0)
	
	_FresnelScale ("FresnelScale", Range (0.15, 4.0)) = 0.75	

	_BaseColor ("Base color", COLOR)  = ( .54, .95, .99, 0.5)	
	_ReflectionColor ("Reflection color", COLOR)  = ( .54, .95, .99, 0.5)	
	_SpecularColor ("Specular color", COLOR)  = ( .72, .72, .72, 1)
	
	_WorldLightDir ("Specular light direction", Vector) = (0.0, 0.1, -0.5, 0.0)
	_Shininess ("Shininess", Range (2.0, 500.0)) = 200.0	
	
	_Foam ("Foam (intensity, cutoff)", Vector) = (0.1, 0.375, 0.0, 0.0)
	
	_GerstnerIntensity("Per vertex displacement", Float) = 1.0
	_GAmplitude ("Wave Amplitude", Vector) = (0.3 ,0.35, 0.25, 0.25)
	_GFrequency ("Wave Frequency", Vector) = (1.3, 1.35, 1.25, 1.25)
	_GSteepness ("Wave Steepness", Vector) = (1.0, 1.0, 1.0, 1.0)
	_GSpeed ("Wave Speed", Vector) = (1.2, 1.375, 1.1, 1.5)
	_GDirectionAB ("Wave Direction", Vector) = (0.3 ,0.85, 0.85, 0.25)
	_GDirectionCD ("Wave Direction", Vector) = (0.1 ,0.9, 0.5, 0.5)	
} 


#LINE 353


Subshader 
{ 
	Tags {"RenderType"="Transparent" "Queue"="Transparent"}
	
	Lod 500
	ColorMask RGB
	
	GrabPass { "_RefractionTex" }
	
	Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 26 to 198
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec4 tmpvar_3;
  vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_5.xz;
  vec3 offsets_i0;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_8.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_8.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_8.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_5.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_15;
  tmpvar_15 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_16;
  tmpvar_16.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_17;
  tmpvar_17 = cos (((_GFrequency * tmpvar_16) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_14.xz;
  tmpvar_18.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.yw;
  tmpvar_19.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  tmpvar_3.xyz = (tmpvar_4 - _WorldSpaceCameraPos);
  vec4 tmpvar_21;
  tmpvar_21 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * 0.5);
  o_i0 = tmpvar_22;
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_21.zw;
  grabPassPos.xy = ((tmpvar_21.xy + tmpvar_21.w) * 0.5);
  grabPassPos.zw = tmpvar_21.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_21;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec4 edgeBlendFactors;
  vec4 rtRefractions;
  vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions = texture2DProj (_RefractionTex, tmpvar_5);
  vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4));
  float tmpvar_8;
  tmpvar_8 = 1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_5).x) + _ZBufferParams.w));
  if ((tmpvar_8 < xlv_TEXCOORD3.z)) {
    rtRefractions = tmpvar_6;
  };
  vec4 tmpvar_9;
  tmpvar_9 = clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_9;
  edgeBlendFactors.y = (1.0 - tmpvar_9.y);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_10;
  tmpvar_10 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_11;
  tmpvar_11 = (mix (mix (rtRefractions, tmpvar_10, tmpvar_10.wwww), mix (tmpvar_7, _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_11;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_11.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 198 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyxz
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.xzzw
mov r2.zw, r2.xyyw
mov r2.xy, r1.ywzw
dp4 r1.y, r0, r2
dp4 r1.x, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.z, r6.y
mov r1.w, r5.y
dp4 r0.w, r1, c16
mov r4.y, r0.w
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c3
dp4 r4.x, r1, c0
dp4 r4.y, r1, c1
mov r2.y, r4
mov r2.w, r3
dp4 r2.z, r1, c2
mov r2.x, r4
mul r3.xyz, r2.xyww, c22.y
mov o0, r2
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
mov r4.y, -r4
add r0.xy, r3.w, r4
dp4 r2.y, r1, c6
dp4 r2.x, r1, c4
mov r0.z, c8.x
mad r1, c15, r0.z, r2.xyxy
mov o4.zw, r2
mov o5.zw, r2
mul o5.xy, r0, c22.y
mul o3, r1, c14
mov_sat o2.w, r0
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = refrFix;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_14;
  highp float tmpvar_15;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_15 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_15;
  vec4 tmpvar_16;
  tmpvar_16 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_16;
  edgeBlendFactors.y = (1.0 - tmpvar_16.y);
  highp vec2 tmpvar_17;
  tmpvar_17 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_17;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_18;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_18 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_19;
  tmpvar_19 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = mix (mix (rtRefractions, tmpvar_18, tmpvar_18.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_21;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_23;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = refrFix;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_14;
  highp float tmpvar_15;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_15 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_15;
  vec4 tmpvar_16;
  tmpvar_16 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_16;
  edgeBlendFactors.y = (1.0 - tmpvar_16.y);
  highp vec2 tmpvar_17;
  tmpvar_17 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_17;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_18;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_18 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_19;
  tmpvar_19 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = mix (mix (rtRefractions, tmpvar_18, tmpvar_18.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_21;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_23;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec4 tmpvar_3;
  vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_5.xz;
  vec3 offsets_i0;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_8.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_8.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_8.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_5.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_15;
  tmpvar_15 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_16;
  tmpvar_16.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_17;
  tmpvar_17 = cos (((_GFrequency * tmpvar_16) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_14.xz;
  tmpvar_18.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.yw;
  tmpvar_19.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  tmpvar_3.xyz = (tmpvar_4 - _WorldSpaceCameraPos);
  vec4 tmpvar_21;
  tmpvar_21 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * 0.5);
  o_i0 = tmpvar_22;
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_21.zw;
  grabPassPos.xy = ((tmpvar_21.xy + tmpvar_21.w) * 0.5);
  grabPassPos.zw = tmpvar_21.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_21;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec4 edgeBlendFactors;
  vec4 rtRefractions;
  vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions = texture2DProj (_RefractionTex, tmpvar_5);
  float tmpvar_7;
  tmpvar_7 = 1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_5).x) + _ZBufferParams.w));
  if ((tmpvar_7 < xlv_TEXCOORD3.z)) {
    rtRefractions = tmpvar_6;
  };
  vec4 tmpvar_8;
  tmpvar_8 = clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_8;
  edgeBlendFactors.y = (1.0 - tmpvar_8.y);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_9;
  tmpvar_9 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_10;
  tmpvar_10 = (mix (mix (rtRefractions, tmpvar_9, tmpvar_9.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_10;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_10.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 198 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyxz
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.xzzw
mov r2.zw, r2.xyyw
mov r2.xy, r1.ywzw
dp4 r1.y, r0, r2
dp4 r1.x, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.z, r6.y
mov r1.w, r5.y
dp4 r0.w, r1, c16
mov r4.y, r0.w
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c3
dp4 r4.x, r1, c0
dp4 r4.y, r1, c1
mov r2.y, r4
mov r2.w, r3
dp4 r2.z, r1, c2
mov r2.x, r4
mul r3.xyz, r2.xyww, c22.y
mov o0, r2
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
mov r4.y, -r4
add r0.xy, r3.w, r4
dp4 r2.y, r1, c6
dp4 r2.x, r1, c4
mov r0.z, c8.x
mad r1, c15, r0.z, r2.xyxy
mov o4.zw, r2
mov o5.zw, r2
mul o5.xy, r0, c22.y
mul o3, r1, c14
mov_sat o2.w, r0
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_8;
  highp float tmpvar_9;
  highp float z;
  z = refrFix;
  tmpvar_9 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_9 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_12;
  highp float tmpvar_13;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_13 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_13;
  vec4 tmpvar_14;
  tmpvar_14 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_14;
  edgeBlendFactors.y = (1.0 - tmpvar_14.y);
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_15;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_16;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_16 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_17;
  tmpvar_17 = mix (mix (rtRefractions, tmpvar_16, tmpvar_16.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_18;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_19;
  tmpvar_19 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_20;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_8;
  highp float tmpvar_9;
  highp float z;
  z = refrFix;
  tmpvar_9 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_9 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_12;
  highp float tmpvar_13;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_13 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_13;
  vec4 tmpvar_14;
  tmpvar_14 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_14;
  edgeBlendFactors.y = (1.0 - tmpvar_14.y);
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_15;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_16;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_16 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_17;
  tmpvar_17 = mix (mix (rtRefractions, tmpvar_16, tmpvar_16.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_18;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_19;
  tmpvar_19 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_20;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec4 tmpvar_3;
  vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_5.xz;
  vec3 offsets_i0;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_8.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_8.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_8.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_5.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_15;
  tmpvar_15 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_16;
  tmpvar_16.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_17;
  tmpvar_17 = cos (((_GFrequency * tmpvar_16) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_14.xz;
  tmpvar_18.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.yw;
  tmpvar_19.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  tmpvar_3.xyz = (tmpvar_4 - _WorldSpaceCameraPos);
  vec4 tmpvar_21;
  tmpvar_21 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * 0.5);
  o_i0 = tmpvar_22;
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_21.zw;
  grabPassPos.xy = ((tmpvar_21.xy + tmpvar_21.w) * 0.5);
  grabPassPos.zw = tmpvar_21.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_21;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_5;
  tmpvar_5 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_6;
  tmpvar_6 = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_4)), tmpvar_5, tmpvar_5.wwww), mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_6;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_6.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 198 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyxz
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.xzzw
mov r2.zw, r2.xyyw
mov r2.xy, r1.ywzw
dp4 r1.y, r0, r2
dp4 r1.x, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.z, r6.y
mov r1.w, r5.y
dp4 r0.w, r1, c16
mov r4.y, r0.w
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c3
dp4 r4.x, r1, c0
dp4 r4.y, r1, c1
mov r2.y, r4
mov r2.w, r3
dp4 r2.z, r1, c2
mov r2.x, r4
mul r3.xyz, r2.xyww, c22.y
mov o0, r2
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
mov r4.y, -r4
add r0.xy, r3.w, r4
dp4 r2.y, r1, c6
dp4 r2.x, r1, c4
mov r0.z, c8.x
mad r1, c15, r0.z, r2.xyxy
mov o4.zw, r2
mov o5.zw, r2
mul o5.xy, r0, c22.y
mul o3, r1, c14
mov_sat o2.w, r0
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_11;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_12;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_12 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (mix (rtRefractions, tmpvar_12, tmpvar_12.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_15;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_17;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_11;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_12;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_12 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (mix (rtRefractions, tmpvar_12, tmpvar_12.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_15;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_17;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec4 tmpvar_3;
  vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_5.xz;
  vec3 offsets_i0;
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_7;
  tmpvar_7 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_8;
  tmpvar_8.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_8.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_8.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_8.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_9;
  tmpvar_9 = (_GFrequency * tmpvar_8);
  vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + tmpvar_10));
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + tmpvar_10)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_5.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_15;
  tmpvar_15 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_16;
  tmpvar_16.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_17;
  tmpvar_17 = cos (((_GFrequency * tmpvar_16) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_14.xz;
  tmpvar_18.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.yw;
  tmpvar_19.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  tmpvar_3.xyz = (tmpvar_4 - _WorldSpaceCameraPos);
  vec4 tmpvar_21;
  tmpvar_21 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * 0.5);
  o_i0 = tmpvar_22;
  vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0.zw = tmpvar_21.zw;
  grabPassPos.xy = ((tmpvar_21.xy + tmpvar_21.w) * 0.5);
  grabPassPos.zw = tmpvar_21.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_21;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_5;
  tmpvar_5 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_6;
  tmpvar_6 = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_4)), tmpvar_5, tmpvar_5.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_6;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_6.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 198 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyxz
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.xzzw
mov r2.zw, r2.xyyw
mov r2.xy, r1.ywzw
dp4 r1.y, r0, r2
dp4 r1.x, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r2.x, r0, r0
rsq r2.z, r2.x
mul o1.xyz, r2.z, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.z, r6.y
mov r1.w, r5.y
dp4 r0.w, r1, c16
mov r4.y, r0.w
add r1.xyz, v0, r4
mov r1.w, v0
dp4 r3.w, r1, c3
dp4 r4.x, r1, c0
dp4 r4.y, r1, c1
mov r2.y, r4
mov r2.w, r3
dp4 r2.z, r1, c2
mov r2.x, r4
mul r3.xyz, r2.xyww, c22.y
mov o0, r2
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
mov r4.y, -r4
add r0.xy, r3.w, r4
dp4 r2.y, r1, c6
dp4 r2.x, r1, c4
mov r0.z, c8.x
mad r1, c15, r0.z, r2.xyxy
mov o4.zw, r2
mov o5.zw, r2
mul o5.xy, r0, c22.y
mul o3, r1, c14
mov_sat o2.w, r0
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_10;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_10 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = mix (mix (rtRefractions, tmpvar_10, tmpvar_10.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_12;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_13;
  tmpvar_13 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_14;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_5;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_7;
  tmpvar_7 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_8;
  tmpvar_8.x = dot (directionAB.xy, xzVtx);
  tmpvar_8.y = dot (directionAB.zw, xzVtx);
  tmpvar_8.z = dot (directionCD.xy, xzVtx);
  tmpvar_8.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_9;
  tmpvar_9 = (frequency * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (_Time.yyyy * speed);
  TIME = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = cos ((tmpvar_9 + TIME));
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_6.xz;
  tmpvar_12.zw = tmpvar_7.xz;
  offsets_i0.x = dot (tmpvar_11, tmpvar_12);
  mediump vec4 tmpvar_13;
  tmpvar_13.xy = tmpvar_6.yw;
  tmpvar_13.zw = tmpvar_7.yw;
  offsets_i0.z = dot (tmpvar_11, tmpvar_13);
  offsets_i0.y = dot (sin ((tmpvar_9 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_15;
  tmpvar_15 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_16;
  tmpvar_16.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_16.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_16.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_16.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = cos (((frequency * tmpvar_16) + TIME_i0));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_14.xz;
  tmpvar_19.zw = tmpvar_15.xz;
  nrml_i0_i0.x = -(dot (tmpvar_18, tmpvar_19));
  mediump vec4 tmpvar_20;
  tmpvar_20.xy = tmpvar_14.yw;
  tmpvar_20.zw = tmpvar_15.yw;
  nrml_i0_i0.z = -(dot (tmpvar_18, tmpvar_20));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_21;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_22;
  tmpvar_22 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_22;
  tmpvar_3.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_23;
  tmpvar_23 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_23.zw;
  grabPassPos.xy = ((tmpvar_23.xy + tmpvar_23.w) * 0.5);
  grabPassPos.zw = tmpvar_23.zw;
  tmpvar_2.xyz = tmpvar_21;
  tmpvar_3.w = clamp (offsets_i0.y, 0.0, 1.0);
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_23;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_10;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_10 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = mix (mix (rtRefractions, tmpvar_10, tmpvar_10.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_12;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_13;
  tmpvar_13 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_14;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.xyz = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  grabPassPos.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec4 edgeBlendFactors;
  vec4 rtRefractions;
  vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions = texture2DProj (_RefractionTex, tmpvar_5);
  vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4));
  float tmpvar_8;
  tmpvar_8 = 1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_5).x) + _ZBufferParams.w));
  if ((tmpvar_8 < xlv_TEXCOORD3.z)) {
    rtRefractions = tmpvar_6;
  };
  vec4 tmpvar_9;
  tmpvar_9 = clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_9;
  edgeBlendFactors.y = (1.0 - tmpvar_9.y);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_10;
  tmpvar_10 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_11;
  tmpvar_11 = (mix (mix (rtRefractions, tmpvar_10, tmpvar_10.wwww), mix (tmpvar_7, _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_11;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_11.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 26 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.00000000, 0.50000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.z, v0, c3
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mov r0.y, r2
mov r0.w, r2.z
dp4 r0.z, v0, c2
mov r0.x, r2
mul r1.xyz, r0.xyww, c14.y
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mul o3, r1, c12
mov r2.y, -r2
add r1.xy, r2.z, r2
mov o4.zw, r0
mov o5.zw, r0
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.xzxz
add o2.xyz, r0, -c11
mul o5.xy, r1, c14.y
mov o2.w, c14.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = refrFix;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_14;
  highp float tmpvar_15;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_15 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_15;
  vec4 tmpvar_16;
  tmpvar_16 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_16;
  edgeBlendFactors.y = (1.0 - tmpvar_16.y);
  highp vec2 tmpvar_17;
  tmpvar_17 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_17;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_18;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_18 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_19;
  tmpvar_19 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = mix (mix (rtRefractions, tmpvar_18, tmpvar_18.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_21;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_23;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = refrFix;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_11 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_14;
  highp float tmpvar_15;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_15 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_15;
  vec4 tmpvar_16;
  tmpvar_16 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_16;
  edgeBlendFactors.y = (1.0 - tmpvar_16.y);
  highp vec2 tmpvar_17;
  tmpvar_17 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_17;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_18;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_18 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_19;
  tmpvar_19 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = mix (mix (rtRefractions, tmpvar_18, tmpvar_18.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_21;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_22;
  tmpvar_22 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_23;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.xyz = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  grabPassPos.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec4 edgeBlendFactors;
  vec4 rtRefractions;
  vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + tmpvar_4);
  vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractions = texture2DProj (_RefractionTex, tmpvar_5);
  float tmpvar_7;
  tmpvar_7 = 1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, tmpvar_5).x) + _ZBufferParams.w));
  if ((tmpvar_7 < xlv_TEXCOORD3.z)) {
    rtRefractions = tmpvar_6;
  };
  vec4 tmpvar_8;
  tmpvar_8 = clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_8;
  edgeBlendFactors.y = (1.0 - tmpvar_8.y);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_9;
  tmpvar_9 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_10;
  tmpvar_10 = (mix (mix (rtRefractions, tmpvar_9, tmpvar_9.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_10;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_10.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 26 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.00000000, 0.50000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.z, v0, c3
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mov r0.y, r2
mov r0.w, r2.z
dp4 r0.z, v0, c2
mov r0.x, r2
mul r1.xyz, r0.xyww, c14.y
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mul o3, r1, c12
mov r2.y, -r2
add r1.xy, r2.z, r2
mov o4.zw, r0
mov o5.zw, r0
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.xzxz
add o2.xyz, r0, -c11
mul o5.xy, r1, c14.y
mov o2.w, c14.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_8;
  highp float tmpvar_9;
  highp float z;
  z = refrFix;
  tmpvar_9 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_9 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_12;
  highp float tmpvar_13;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_13 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_13;
  vec4 tmpvar_14;
  tmpvar_14 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_14;
  edgeBlendFactors.y = (1.0 - tmpvar_14.y);
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_15;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_16;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_16 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_17;
  tmpvar_17 = mix (mix (rtRefractions, tmpvar_16, tmpvar_16.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_18;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_19;
  tmpvar_19 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_20;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  mediump float depth;
  mediump vec4 edgeBlendFactors;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump float refrFix;
  mediump vec4 rtRefractionsNoDistort;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  edgeBlendFactors = vec4(1.0, 0.0, 0.0, 0.0);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, xlv_TEXCOORD4);
  rtRefractionsNoDistort = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, grabWithOffset).x;
  refrFix = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_8;
  highp float tmpvar_9;
  highp float z;
  z = refrFix;
  tmpvar_9 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  if ((tmpvar_9 < xlv_TEXCOORD3.z)) {
    rtRefractions = rtRefractionsNoDistort;
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_11;
  lowp float tmpvar_12;
  tmpvar_12 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_12;
  highp float tmpvar_13;
  highp float z_i0;
  z_i0 = depth;
  tmpvar_13 = 1.0/(((_ZBufferParams.z * z_i0) + _ZBufferParams.w));
  depth = tmpvar_13;
  vec4 tmpvar_14;
  tmpvar_14 = clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.w)), 0.0, 1.0);
  edgeBlendFactors = tmpvar_14;
  edgeBlendFactors.y = (1.0 - tmpvar_14.y);
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_15;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_16;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_16 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_17;
  tmpvar_17 = mix (mix (rtRefractions, tmpvar_16, tmpvar_16.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_18;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_19;
  tmpvar_19 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * (edgeBlendFactors.y + clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0))));
  baseColor.xyz = tmpvar_20;
  baseColor.w = edgeBlendFactors.x;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.xyz = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  grabPassPos.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_5;
  tmpvar_5 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_6;
  tmpvar_6 = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_4)), tmpvar_5, tmpvar_5.wwww), mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_6;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_6.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 26 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.00000000, 0.50000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.z, v0, c3
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mov r0.y, r2
mov r0.w, r2.z
dp4 r0.z, v0, c2
mov r0.x, r2
mul r1.xyz, r0.xyww, c14.y
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mul o3, r1, c12
mov r2.y, -r2
add r1.xy, r2.z, r2
mov o4.zw, r0
mov o5.zw, r0
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.xzxz
add o2.xyz, r0, -c11
mul o5.xy, r1, c14.y
mov o2.w, c14.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_11;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_12;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_12 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (mix (rtRefractions, tmpvar_12, tmpvar_12.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_15;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_17;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_11;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_12;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_12 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww);
  reflectionColor = tmpvar_13;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (mix (rtRefractions, tmpvar_12, tmpvar_12.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_15;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_16;
  tmpvar_16 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_17;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2.xyz = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 grabPassPos;
  vec4 o_i0;
  vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  grabPassPos.xy = ((tmpvar_3.xy + tmpvar_3.w) * 0.5);
  grabPassPos.zw = tmpvar_3.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform float _Shininess;
uniform sampler2D _RefractionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _Foam;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((xlv_TEXCOORD0.xyz + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  vec4 tmpvar_5;
  tmpvar_5 = (_BaseColor - ((xlv_TEXCOORD1.w * _InvFadeParemeter.w) * vec4(0.15, 0.03, 0.01, 0.0)));
  vec4 tmpvar_6;
  tmpvar_6 = (mix (mix (texture2DProj (_RefractionTex, (xlv_TEXCOORD4 + tmpvar_4)), tmpvar_5, tmpvar_5.wwww), _ReflectionColor, vec4(clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor = tmpvar_6;
  vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  baseColor.xyz = (tmpvar_6.xyz + ((((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125).xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 26 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c14, 0.00000000, 0.50000000, 1.00000000, 0
dcl_position0 v0
dp4 r2.z, v0, c3
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mov r0.y, r2
mov r0.w, r2.z
dp4 r0.z, v0, c2
mov r0.x, r2
mul r1.xyz, r0.xyww, c14.y
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mul o3, r1, c12
mov r2.y, -r2
add r1.xy, r2.z, r2
mov o4.zw, r0
mov o5.zw, r0
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.xzxz
add o2.xyz, r0, -c11
mul o5.xy, r1, c14.y
mov o2.w, c14.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_10;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_10 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = mix (mix (rtRefractions, tmpvar_10, tmpvar_10.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_12;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_13;
  tmpvar_13 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_14;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_4;
  tmpvar_2.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 grabPassPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * 0.5);
  o_i0 = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_7 + tmpvar_6.w);
  o_i0.zw = tmpvar_5.zw;
  grabPassPos.xy = ((tmpvar_5.xy + tmpvar_5.w) * 0.5);
  grabPassPos.zw = tmpvar_5.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_2.w = 0.0;
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
  xlv_TEXCOORD4 = grabPassPos;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform sampler2D _ShoreTex;
uniform highp float _Shininess;
uniform sampler2D _RefractionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _Foam;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 reflectionColor;
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtRefractions;
  mediump vec4 grabWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = xlv_TEXCOORD0.xyz;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1.xyz);
  viewVector = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4 + distortOffset);
  grabWithOffset = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_RefractionTex, grabWithOffset);
  rtRefractions = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  mediump vec4 tmpvar_10;
  mediump vec4 baseColor_i0;
  baseColor_i0 = _BaseColor;
  mediump float extinctionAmount;
  extinctionAmount = (xlv_TEXCOORD1.w * _InvFadeParemeter.w);
  tmpvar_10 = (baseColor_i0 - (extinctionAmount * vec4(0.15, 0.03, 0.01, 0.0)));
  reflectionColor = _ReflectionColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = mix (mix (rtRefractions, tmpvar_10, tmpvar_10.wwww), reflectionColor, vec4(clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0)));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_12;
  mediump vec4 coords_i0;
  coords_i0 = (xlv_TEXCOORD2 * 2.0);
  mediump vec4 foam_i0;
  lowp vec4 tmpvar_13;
  tmpvar_13 = ((texture2D (_ShoreTex, coords_i0.xy) * texture2D (_ShoreTex, coords_i0.zw)) - 0.125);
  foam_i0 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (baseColor.xyz + ((foam_i0.xyz * _Foam.x) * clamp ((xlv_TEXCOORD1.w - _Foam.y), 0.0, 1.0)));
  baseColor.xyz = tmpvar_14;
  baseColor.w = 1.0;
  gl_FragData[0] = baseColor;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 52 to 65, TEX: 5 to 9
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 9 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ReflectionTex] 2D
SetTexture 4 [_ShoreTex] 2D
"ps_3_0
; 65 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c11, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c12, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c10.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c10.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c10.y
mul r0.xy, r0, c10.w
add r3, r0, v4
texldp r1.x, r3, s2
add r0, v3, r0
mad r1.x, r1, c0.z, c0.w
rcp r1.x, r1.x
add r1.w, -v3.z, r1.x
texldp r0.xyz, r0, s3
texldp r1.xyz, v4, s1
texldp r3.xyz, r3, s1
cmp_pp r3.xyz, r1.w, r3, r1
mul r2.w, v1, c4
mov_pp r1, c2
mad_pp r1, -r2.w, c11, r1
add_pp r1.xyz, r1, -r3
mad_pp r4.xyz, r1.w, r1, r3
add_pp r3.xyz, -r0, c3
mad_pp r0.xyz, r3, c3.w, r0
add_pp r5.xyz, r0, -r4
dp3 r1.x, v1, v1
rsq r0.w, r1.x
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r0.y, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r2, -r3
max_pp r0.y, r0, c10
max_pp r0.x, r0, c10.y
pow r1, r0.x, c5.x
add_pp_sat r2.x, -r0.y, c10.z
pow_pp r0, r2.x, c7.z
mov r0.w, r1.x
mov_pp r0.z, r0.x
mov_pp r0.y, c7.w
add_pp r0.x, c10.z, -r0.y
mad_pp_sat r0.x, r0, r0.z, c7.w
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r2.w, r0.x, c0.z, c0
mul r1, v2, c12.x
texld r0.xyz, r1, s4
texld r1.xyz, r1.zwzw, s4
mad r0.xyz, r0, r1, c12.y
rcp r2.w, r2.w
add r1.w, r2, -v3
mul_sat r1.xy, r1.w, c4
max r0.w, r0, c10.y
add_sat r1.z, v1.w, -c9.y
add_pp r1.y, -r1, c10.z
add r1.y, r1, r1.z
mul r0.xyz, r0, c9.x
mul r0.xyz, r0, r1.y
mad r2.xyz, r0.w, c1, r2
add_pp oC0.xyz, r2, r0
mov_pp oC0.w, r1.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 9 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ShoreTex] 2D
"ps_3_0
; 62 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c10, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c11, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c12, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c10.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c10.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mul r0.xy, r0, c10.w
mov_pp r0.zw, c10.y
add r1, v4, r0
texldp r0.x, r1, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r1.xyz, r1, s1
texldp r0.xyz, v4, s1
cmp_pp r0.xyz, r0.w, r1, r0
dp3 r0.w, v1, v1
mul r2.w, v1, c4
mov_pp r1, c2
mad_pp r1, -r2.w, c11, r1
add_pp r3.xyz, r1, -r0
mad_pp r4.xyz, r1.w, r3, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r0.y, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r2, -r3
max_pp r0.y, r0, c10
max_pp r0.x, r0, c10.y
pow r1, r0.x, c5.x
add_pp_sat r2.x, -r0.y, c10.z
pow_pp r0, r2.x, c7.z
mov r0.w, r1.x
mov_pp r0.z, r0.x
mov_pp r0.y, c7.w
add_pp r0.x, c10.z, -r0.y
mad_pp_sat r0.x, r0, r0.z, c7.w
add_pp r5.xyz, -r4, c3
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r2.w, r0.x, c0.z, c0
mul r1, v2, c12.x
texld r0.xyz, r1, s3
texld r1.xyz, r1.zwzw, s3
mad r0.xyz, r0, r1, c12.y
rcp r2.w, r2.w
add r1.w, r2, -v3
mul_sat r1.xy, r1.w, c4
max r0.w, r0, c10.y
add_sat r1.z, v1.w, -c9.y
add_pp r1.y, -r1, c10.z
add r1.y, r1, r1.z
mul r0.xyz, r0, c9.x
mul r0.xyz, r0, r1.y
mad r2.xyz, r0.w, c1, r2
add_pp oC0.xyz, r2, r0
mov_pp oC0.w, r1.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
Vector 8 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ReflectionTex] 2D
SetTexture 3 [_ShoreTex] 2D
"ps_3_0
; 54 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c10, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c11, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c6.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
mul r0.xy, r3.xzzw, c6.y
mul r1.xy, r0, c9.w
mov_pp r1.zw, c9.y
add r0, r1, v4
texldp r2.xyz, r0, s1
add r1, v3, r1
texldp r1.xyz, r1, s2
mul r2.w, v1, c3
mov_pp r0, c1
mad_pp r0, -r2.w, c10, r0
add_pp r0.xyz, r0, -r2
mad_pp r0.xyz, r0.w, r0, r2
add_pp r2.xyz, -r1, c2
mad_pp r1.xyz, r2, c2.w, r1
add_pp r5.xyz, r1, -r0
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r4.xyz, r2, c5
dp3 r0.w, r4, r4
mul_pp r1.xz, r3, c7.x
mov_pp r1.y, r3
dp3_pp r1.w, -r2, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r4
max_pp r1.w, r1, c9.y
dp3_pp r0.w, r3, -r1
add_pp_sat r2.x, -r1.w, c9.z
pow_pp r1, r2.x, c6.z
max_pp r0.w, r0, c9.y
pow r2, r0.w, c4.x
mov_pp r0.w, c6
add_pp r0.w, c9.z, -r0
mad_pp_sat r0.w, r0, r1.x, c6
mad_pp r1.xyz, r0.w, r5, r0
mul r0, v2, c11.x
mov r1.w, r2.x
texld r2.xyz, r0.zwzw, s3
texld r0.xyz, r0, s3
mad r0.xyz, r0, r2, c11.y
add_sat r0.w, v1, -c8.y
mul r0.xyz, r0, c8.x
mul r0.xyz, r0, r0.w
max r0.w, r1, c9.y
mad r1.xyz, r0.w, c0, r1
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9.z
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
Vector 8 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ShoreTex] 2D
"ps_3_0
; 52 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c10, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c11, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord4 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c6.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c6.y
mul r1.w, v1, c3
mov_pp r2, c1
mad_pp r2, -r1.w, c10, r2
mov_pp r0.zw, c9.y
mul r0.xy, r0, c9.w
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r2.xyz, r2, -r0
mad_pp r4.xyz, r2.w, r2, r0
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r3.xyz, r2, c5
dp3 r0.w, r3, r3
mul_pp r0.xz, r1, c7.x
mov_pp r0.y, r1
dp3_pp r1.w, -r2, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r3
dp3_pp r0.x, r1, -r0
max_pp r0.w, r1, c9.y
add_pp_sat r1.x, -r0.w, c9.z
max_pp r2.x, r0, c9.y
pow_pp r0, r1.x, c6.z
pow r1, r2.x, c4.x
mov_pp r0.z, r0.x
mov_pp r0.y, c6.w
add_pp r0.x, c9.z, -r0.y
mad_pp_sat r0.x, r0, r0.z, c6.w
add_pp r5.xyz, -r4, c2
mad_pp r2.xyz, r0.x, r5, r4
mul r0, v2, c11.x
mov r1.w, r1.x
texld r1.xyz, r0.zwzw, s2
texld r0.xyz, r0, s2
mad r0.xyz, r0, r1, c11.y
add_sat r0.w, v1, -c8.y
mul r0.xyz, r0, c8.x
mul r0.xyz, r0, r0.w
max r0.w, r1, c9.y
mad r1.xyz, r0.w, c0, r2
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9.z
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 9 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ReflectionTex] 2D
SetTexture 4 [_ShoreTex] 2D
"ps_3_0
; 65 ALU, 9 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c10, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c11, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c12, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c10.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c10.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c10.y
mul r0.xy, r0, c10.w
add r3, r0, v4
texldp r1.x, r3, s2
add r0, v3, r0
mad r1.x, r1, c0.z, c0.w
rcp r1.x, r1.x
add r1.w, -v3.z, r1.x
texldp r0.xyz, r0, s3
texldp r1.xyz, v4, s1
texldp r3.xyz, r3, s1
cmp_pp r3.xyz, r1.w, r3, r1
mul r2.w, v1, c4
mov_pp r1, c2
mad_pp r1, -r2.w, c11, r1
add_pp r1.xyz, r1, -r3
mad_pp r4.xyz, r1.w, r1, r3
add_pp r3.xyz, -r0, c3
mad_pp r0.xyz, r3, c3.w, r0
add_pp r5.xyz, r0, -r4
dp3 r1.x, v1, v1
rsq r0.w, r1.x
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r0.y, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r2, -r3
max_pp r0.y, r0, c10
max_pp r0.x, r0, c10.y
pow r1, r0.x, c5.x
add_pp_sat r2.x, -r0.y, c10.z
pow_pp r0, r2.x, c7.z
mov r0.w, r1.x
mov_pp r0.z, r0.x
mov_pp r0.y, c7.w
add_pp r0.x, c10.z, -r0.y
mad_pp_sat r0.x, r0, r0.z, c7.w
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r2.w, r0.x, c0.z, c0
mul r1, v2, c12.x
texld r0.xyz, r1, s4
texld r1.xyz, r1.zwzw, s4
mad r0.xyz, r0, r1, c12.y
rcp r2.w, r2.w
add r1.w, r2, -v3
mul_sat r1.xy, r1.w, c4
max r0.w, r0, c10.y
add_sat r1.z, v1.w, -c9.y
add_pp r1.y, -r1, c10.z
add r1.y, r1, r1.z
mul r0.xyz, r0, c9.x
mul r0.xyz, r0, r1.y
mad r2.xyz, r0.w, c1, r2
add_pp oC0.xyz, r2, r0
mov_pp oC0.w, r1.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
Vector 9 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
SetTexture 3 [_ShoreTex] 2D
"ps_3_0
; 62 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c10, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c11, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c12, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c10.x
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c10.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mul r0.xy, r0, c10.w
mov_pp r0.zw, c10.y
add r1, v4, r0
texldp r0.x, r1, s2
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.w, -v3.z, r0.x
texldp r1.xyz, r1, s1
texldp r0.xyz, v4, s1
cmp_pp r0.xyz, r0.w, r1, r0
dp3 r0.w, v1, v1
mul r2.w, v1, c4
mov_pp r1, c2
mad_pp r1, -r2.w, c11, r1
add_pp r3.xyz, r1, -r0
mad_pp r4.xyz, r1.w, r3, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
add r3.xyz, r1, c6
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r0.y, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r2, -r3
max_pp r0.y, r0, c10
max_pp r0.x, r0, c10.y
pow r1, r0.x, c5.x
add_pp_sat r2.x, -r0.y, c10.z
pow_pp r0, r2.x, c7.z
mov r0.w, r1.x
mov_pp r0.z, r0.x
mov_pp r0.y, c7.w
add_pp r0.x, c10.z, -r0.y
mad_pp_sat r0.x, r0, r0.z, c7.w
add_pp r5.xyz, -r4, c3
mad_pp r2.xyz, r0.x, r5, r4
texldp r0.x, v3, s2
mad r2.w, r0.x, c0.z, c0
mul r1, v2, c12.x
texld r0.xyz, r1, s3
texld r1.xyz, r1.zwzw, s3
mad r0.xyz, r0, r1, c12.y
rcp r2.w, r2.w
add r1.w, r2, -v3
mul_sat r1.xy, r1.w, c4
max r0.w, r0, c10.y
add_sat r1.z, v1.w, -c9.y
add_pp r1.y, -r1, c10.z
add r1.y, r1, r1.z
mul r0.xyz, r0, c9.x
mul r0.xyz, r0, r1.y
mad r2.xyz, r0.w, c1, r2
add_pp oC0.xyz, r2, r0
mov_pp oC0.w, r1.x
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
Vector 8 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ReflectionTex] 2D
SetTexture 3 [_ShoreTex] 2D
"ps_3_0
; 54 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c10, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c11, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3
dcl_texcoord4 v4
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c6.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
mul r0.xy, r3.xzzw, c6.y
mul r1.xy, r0, c9.w
mov_pp r1.zw, c9.y
add r0, r1, v4
texldp r2.xyz, r0, s1
add r1, v3, r1
texldp r1.xyz, r1, s2
mul r2.w, v1, c3
mov_pp r0, c1
mad_pp r0, -r2.w, c10, r0
add_pp r0.xyz, r0, -r2
mad_pp r0.xyz, r0.w, r0, r2
add_pp r2.xyz, -r1, c2
mad_pp r1.xyz, r2, c2.w, r1
add_pp r5.xyz, r1, -r0
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r4.xyz, r2, c5
dp3 r0.w, r4, r4
mul_pp r1.xz, r3, c7.x
mov_pp r1.y, r3
dp3_pp r1.w, -r2, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, r4
max_pp r1.w, r1, c9.y
dp3_pp r0.w, r3, -r1
add_pp_sat r2.x, -r1.w, c9.z
pow_pp r1, r2.x, c6.z
max_pp r0.w, r0, c9.y
pow r2, r0.w, c4.x
mov_pp r0.w, c6
add_pp r0.w, c9.z, -r0
mad_pp_sat r0.w, r0, r1.x, c6
mad_pp r1.xyz, r0.w, r5, r0
mul r0, v2, c11.x
mov r1.w, r2.x
texld r2.xyz, r0.zwzw, s3
texld r0.xyz, r0, s3
mad r0.xyz, r0, r2, c11.y
add_sat r0.w, v1, -c8.y
mul r0.xyz, r0, c8.x
mul r0.xyz, r0, r0.w
max r0.w, r1, c9.y
mad r1.xyz, r0.w, c0, r1
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9.z
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Vector 3 [_InvFadeParemeter]
Float 4 [_Shininess]
Vector 5 [_WorldLightDir]
Vector 6 [_DistortParams]
Float 7 [_FresnelScale]
Vector 8 [_Foam]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_RefractionTex] 2D
SetTexture 2 [_ShoreTex] 2D
"ps_3_0
; 52 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -1.00000000, 0.00000000, 1.00000000, 10.00000000
def c10, 0.15002441, 0.02999878, 0.01000214, 0.00000000
def c11, 2.00000000, -0.12500000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord4 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.x
mul_pp r0.xy, r0, c6.x
mad_pp r0.xyz, r0.xxyw, c9.zyzw, v0
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
mul r0.xy, r1.xzzw, c6.y
mul r1.w, v1, c3
mov_pp r2, c1
mad_pp r2, -r1.w, c10, r2
mov_pp r0.zw, c9.y
mul r0.xy, r0, c9.w
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r2.xyz, r2, -r0
mad_pp r4.xyz, r2.w, r2, r0
dp3 r0.w, v1, v1
rsq r0.w, r0.w
mul r2.xyz, r0.w, v1
add r3.xyz, r2, c5
dp3 r0.w, r3, r3
mul_pp r0.xz, r1, c7.x
mov_pp r0.y, r1
dp3_pp r1.w, -r2, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r3
dp3_pp r0.x, r1, -r0
max_pp r0.w, r1, c9.y
add_pp_sat r1.x, -r0.w, c9.z
max_pp r2.x, r0, c9.y
pow_pp r0, r1.x, c6.z
pow r1, r2.x, c4.x
mov_pp r0.z, r0.x
mov_pp r0.y, c6.w
add_pp r0.x, c9.z, -r0.y
mad_pp_sat r0.x, r0, r0.z, c6.w
add_pp r5.xyz, -r4, c2
mad_pp r2.xyz, r0.x, r5, r4
mul r0, v2, c11.x
mov r1.w, r1.x
texld r1.xyz, r0.zwzw, s2
texld r0.xyz, r0, s2
mad r0.xyz, r0, r1, c11.y
add_sat r0.w, v1, -c8.y
mul r0.xyz, r0, c8.x
mul r0.xyz, r0, r0.w
max r0.w, r1, c9.y
mad r1.xyz, r0.w, c0, r2
add_pp oC0.xyz, r1, r0
mov_pp oC0.w, c9.z
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

}

#LINE 385

	}
}

Subshader 
{ 	
	Tags {"RenderType"="Transparent" "Queue"="Transparent"}
	
	Lod 300
	ColorMask RGB
	
	Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 18 to 189
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_4.xz;
  vec3 offsets_i0;
  vec4 tmpvar_5;
  tmpvar_5 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_7;
  tmpvar_7.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_7.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_7.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_7.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_8;
  tmpvar_8 = (_GFrequency * tmpvar_7);
  vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + tmpvar_9)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_4.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_13;
  tmpvar_13 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_15;
  tmpvar_15.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_16;
  tmpvar_16 = cos (((_GFrequency * tmpvar_15) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_17;
  tmpvar_17.xy = tmpvar_13.xz;
  tmpvar_17.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_16, tmpvar_17));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.yw;
  tmpvar_18.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_16, tmpvar_18));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_19;
  tmpvar_19 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_19;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  vec4 tmpvar_20;
  tmpvar_20 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_i0;
  vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 0.5);
  o_i0 = tmpvar_21;
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21.x;
  tmpvar_22.y = (tmpvar_21.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_22 + tmpvar_21.w);
  o_i0.zw = tmpvar_20.zw;
  tmpvar_2.xyz = tmpvar_19;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_20;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_5;
  tmpvar_5 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((tmpvar_5 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = (clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_5), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 189 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
dp4 r0.y, r1, c6
dp4 r0.x, r1, c4
mov r0.z, c8.x
mad r0, c15, r0.z, r0.xyxy
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = depth;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_11;
  highp vec2 tmpvar_12;
  tmpvar_12 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_12;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_13;
  tmpvar_13 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_14;
  tmpvar_14 = vec4(clamp ((tmpvar_13 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_15;
  tmpvar_15 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_14);
  baseColor = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_16;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_13), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = depth;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_11;
  highp vec2 tmpvar_12;
  tmpvar_12 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_12;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_13;
  tmpvar_13 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_14;
  tmpvar_14 = vec4(clamp ((tmpvar_13 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_15;
  tmpvar_15 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_14);
  baseColor = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_16;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_13), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_4.xz;
  vec3 offsets_i0;
  vec4 tmpvar_5;
  tmpvar_5 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_7;
  tmpvar_7.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_7.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_7.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_7.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_8;
  tmpvar_8 = (_GFrequency * tmpvar_7);
  vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + tmpvar_9)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_4.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_13;
  tmpvar_13 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_15;
  tmpvar_15.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_16;
  tmpvar_16 = cos (((_GFrequency * tmpvar_15) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_17;
  tmpvar_17.xy = tmpvar_13.xz;
  tmpvar_17.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_16, tmpvar_17));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.yw;
  tmpvar_18.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_16, tmpvar_18));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_19;
  tmpvar_19 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_19;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  vec4 tmpvar_20;
  tmpvar_20 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_i0;
  vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 0.5);
  o_i0 = tmpvar_21;
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21.x;
  tmpvar_22.y = (tmpvar_21.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_22 + tmpvar_21.w);
  o_i0.zw = tmpvar_20.zw;
  tmpvar_2.xyz = tmpvar_19;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_20;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_4;
  tmpvar_4 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, _ReflectionColor, vec4(clamp ((tmpvar_4 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = (clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_4), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 189 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
dp4 r0.y, r1, c6
dp4 r0.x, r1, c4
mov r0.z, c8.x
mad r0, c15, r0.z, r0.xyxy
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_7;
  highp float tmpvar_8;
  highp float z;
  z = depth;
  tmpvar_8 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_10;
  tmpvar_10 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = vec4(clamp ((tmpvar_10 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_12;
  tmpvar_12 = mix (baseColor, _ReflectionColor, tmpvar_11);
  baseColor = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_13;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_10), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_7;
  highp float tmpvar_8;
  highp float z;
  z = depth;
  tmpvar_8 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_10;
  tmpvar_10 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = vec4(clamp ((tmpvar_10 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_12;
  tmpvar_12 = mix (baseColor, _ReflectionColor, tmpvar_11);
  baseColor = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_13;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_10), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_4.xz;
  vec3 offsets_i0;
  vec4 tmpvar_5;
  tmpvar_5 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_7;
  tmpvar_7.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_7.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_7.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_7.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_8;
  tmpvar_8 = (_GFrequency * tmpvar_7);
  vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + tmpvar_9)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_4.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_13;
  tmpvar_13 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_15;
  tmpvar_15.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_16;
  tmpvar_16 = cos (((_GFrequency * tmpvar_15) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_17;
  tmpvar_17.xy = tmpvar_13.xz;
  tmpvar_17.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_16, tmpvar_17));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.yw;
  tmpvar_18.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_16, tmpvar_18));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_19;
  tmpvar_19 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_19;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  vec4 tmpvar_20;
  tmpvar_20 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_i0;
  vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 0.5);
  o_i0 = tmpvar_21;
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21.x;
  tmpvar_22.y = (tmpvar_21.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_22 + tmpvar_21.w);
  o_i0.zw = tmpvar_20.zw;
  tmpvar_2.xyz = tmpvar_19;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_20;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_5;
  tmpvar_5 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((tmpvar_5 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = clamp ((0.5 + tmpvar_5), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 189 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
dp4 r0.y, r1, c6
dp4 r0.x, r1, c4
mov r0.z, c8.x
mad r0, c15, r0.z, r0.xyxy
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_10;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_11;
  tmpvar_11 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_12;
  tmpvar_12 = vec4(clamp ((tmpvar_11 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_12);
  baseColor = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_14;
  baseColor.w = clamp ((0.5 + tmpvar_11), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_10;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_11;
  tmpvar_11 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_12;
  tmpvar_12 = vec4(clamp ((tmpvar_11 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_12);
  baseColor = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_14;
  baseColor.w = clamp ((0.5 + tmpvar_11), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 unity_Scale;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform float _GerstnerIntensity;
uniform vec4 _GSteepness;
uniform vec4 _GSpeed;
uniform vec4 _GFrequency;
uniform vec4 _GDirectionCD;
uniform vec4 _GDirectionAB;
uniform vec4 _GAmplitude;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex;
  vec4 tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * gl_Vertex).xyz;
  vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3.xzz * unity_Scale.w);
  vec2 xzVtx;
  xzVtx = tmpvar_4.xz;
  vec3 offsets_i0;
  vec4 tmpvar_5;
  tmpvar_5 = ((_GSteepness.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_6;
  tmpvar_6 = ((_GSteepness.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_7;
  tmpvar_7.x = dot (_GDirectionAB.xy, xzVtx);
  tmpvar_7.y = dot (_GDirectionAB.zw, xzVtx);
  tmpvar_7.z = dot (_GDirectionCD.xy, xzVtx);
  tmpvar_7.w = dot (_GDirectionCD.zw, xzVtx);
  vec4 tmpvar_8;
  tmpvar_8 = (_GFrequency * tmpvar_7);
  vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * _GSpeed);
  vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + tmpvar_9));
  vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + tmpvar_9)), _GAmplitude);
  vec2 xzVtx_i0;
  xzVtx_i0 = (tmpvar_4.xz + offsets_i0.xz);
  vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  vec4 tmpvar_13;
  tmpvar_13 = ((_GFrequency.xxyy * _GAmplitude.xxyy) * _GDirectionAB);
  vec4 tmpvar_14;
  tmpvar_14 = ((_GFrequency.zzww * _GAmplitude.zzww) * _GDirectionCD);
  vec4 tmpvar_15;
  tmpvar_15.x = dot (_GDirectionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (_GDirectionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (_GDirectionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (_GDirectionCD.zw, xzVtx_i0);
  vec4 tmpvar_16;
  tmpvar_16 = cos (((_GFrequency * tmpvar_15) + (_Time.yyyy * _GSpeed)));
  vec4 tmpvar_17;
  tmpvar_17.xy = tmpvar_13.xz;
  tmpvar_17.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_16, tmpvar_17));
  vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.yw;
  tmpvar_18.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_16, tmpvar_18));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  vec3 tmpvar_19;
  tmpvar_19 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_19;
  tmpvar_1.xyz = (gl_Vertex.xyz + offsets_i0);
  vec4 tmpvar_20;
  tmpvar_20 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_i0;
  vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 0.5);
  o_i0 = tmpvar_21;
  vec2 tmpvar_22;
  tmpvar_22.x = tmpvar_21.x;
  tmpvar_22.y = (tmpvar_21.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_22 + tmpvar_21.w);
  o_i0.zw = tmpvar_20.zw;
  tmpvar_2.xyz = tmpvar_19;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_20;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (tmpvar_3 - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * tmpvar_1).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_4;
  tmpvar_4 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, _ReflectionColor, vec4(clamp ((tmpvar_4 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = clamp ((0.5 + tmpvar_4), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [unity_Scale]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Float 13 [_GerstnerIntensity]
Vector 14 [_BumpTiling]
Vector 15 [_BumpDirection]
Vector 16 [_GAmplitude]
Vector 17 [_GFrequency]
Vector 18 [_GSteepness]
Vector 19 [_GSpeed]
Vector 20 [_GDirectionAB]
Vector 21 [_GDirectionCD]
"vs_3_0
; 189 ALU
dcl_position0 v0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.15915491, 0.50000000, 6.28318501, -3.14159298
def c23, 2.00000000, 1.00000000, 0, 0
mov r0.x, c8.y
mov r2.zw, c18
mul r2.zw, c16, r2
mul r3, r2.zzww, c21
mov r4.zw, r3.xyxz
mul r0, c19, r0.x
mov r3.zw, r3.xyyw
dp4 r7.x, v0, c4
dp4 r7.z, v0, c6
mul r7.yw, r7.xxzz, c11.w
mul r1.xy, r7.ywzw, c20
mul r1.zw, r7.xyyw, c20
add r1.x, r1, r1.y
add r1.y, r1.z, r1.w
mul r1.zw, r7.xyyw, c21.xyxy
mul r2.xy, r7.ywzw, c21.zwzw
add r1.z, r1, r1.w
add r1.w, r2.x, r2.y
mad r1, r1, c17, r0
mad r1.x, r1, c22, c22.y
mad r1.y, r1, c22.x, c22
frc r1.x, r1
mad r1.x, r1, c22.z, c22.w
sincos r9.xy, r1.x
frc r1.y, r1
mad r1.y, r1, c22.z, c22.w
sincos r8.xy, r1.y
mad r1.z, r1, c22.x, c22.y
mad r1.w, r1, c22.x, c22.y
frc r1.z, r1
mad r1.z, r1, c22, c22.w
sincos r6.xy, r1.z
frc r1.w, r1
mad r1.w, r1, c22.z, c22
sincos r5.xy, r1.w
mov r2.xy, c18
mul r2.xy, c16, r2
mul r2, r2.xxyy, c20
mov r4.xy, r2.xzzw
mov r3.xy, r2.ywzw
mov r1.x, r9
mov r1.y, r8.x
mov r1.z, r6.x
mov r1.w, r5.x
dp4 r4.x, r1, r4
dp4 r4.z, r1, r3
add r2.xy, r7.ywzw, r4.xzzw
mul r1.xy, r2, c20
dp4 r7.y, v0, c5
add r1.x, r1, r1.y
mul r1.zw, r2.xyxy, c20
add r1.y, r1.z, r1.w
mul r1.zw, r2.xyxy, c21
add r1.w, r1.z, r1
mul r2.xy, r2, c21
add r1.z, r2.x, r2.y
mad r2, r1, c17, r0
mad r0.y, r2, c22.x, c22
mad r0.x, r2, c22, c22.y
frc r0.x, r0
frc r0.y, r0
mad r0.y, r0, c22.z, c22.w
sincos r1.xy, r0.y
mad r2.x, r0, c22.z, c22.w
sincos r0.xy, r2.x
mad r0.z, r2, c22.x, c22.y
mad r0.w, r2, c22.x, c22.y
frc r0.z, r0
mad r0.z, r0, c22, c22.w
sincos r2.xy, r0.z
frc r0.w, r0
mov r0.y, r1.x
mad r0.w, r0, c22.z, c22
sincos r1.xy, r0.w
mov r0.w, r1.x
mov r1.zw, c17
mov r1.xy, c17
mov r0.z, r2.x
mul r1.zw, c16, r1
mul r2, r1.zzww, c21
mov r3.zw, r2.xyyw
mul r1.xy, c16, r1
mul r1, r1.xxyy, c20
mov r3.xy, r1.ywzw
mov r2.zw, r2.xyxz
mov r2.xy, r1.xzzw
dp4 r1.x, r0, r2
dp4 r1.y, r0, r3
mul r0.xz, -r1.xyyw, c13.x
mov r0.y, c23.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o1.xyz, r0.w, r0
mov r1.x, r9.y
mov r1.y, r8
mov r1.w, r5.y
mov r1.z, r6.y
dp4 r4.y, r1, c16
mov r1.w, v0
add r1.xyz, v0, r4
dp4 r2.w, r1, c3
dp4 r2.z, r1, c2
dp4 r2.x, r1, c0
dp4 r2.y, r1, c1
mul r3.xyz, r2.xyww, c22.y
mov r0.x, r3
mul r0.y, r3, c9.x
mad o4.xy, r3.z, c10.zwzw, r0
dp4 r0.y, r1, c6
dp4 r0.x, r1, c4
mov r0.z, c8.x
mad r0, c15, r0.z, r0.xyxy
mov o0, r2
mov o4.zw, r2
mul o3, r0, c14
add o2.xyz, r7, -c12
mov o1.w, c23.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_7;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_8;
  tmpvar_8 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_9;
  tmpvar_9 = vec4(clamp ((tmpvar_8 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_10;
  tmpvar_10 = mix (baseColor, _ReflectionColor, tmpvar_9);
  baseColor = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_11;
  baseColor.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform mediump float _GerstnerIntensity;
uniform highp vec4 _GSteepness;
uniform highp vec4 _GSpeed;
uniform highp vec4 _GFrequency;
uniform highp vec4 _GDirectionCD;
uniform highp vec4 _GDirectionAB;
uniform highp vec4 _GAmplitude;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  mediump vec2 tileableUv;
  mediump vec3 vtxForAni;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (worldSpaceVertex.xzz * unity_Scale.w);
  vtxForAni = tmpvar_4;
  mediump vec4 amplitude;
  amplitude = _GAmplitude;
  mediump vec4 frequency;
  frequency = _GFrequency;
  mediump vec4 steepness;
  steepness = _GSteepness;
  mediump vec4 speed;
  speed = _GSpeed;
  mediump vec4 directionAB;
  directionAB = _GDirectionAB;
  mediump vec4 directionCD;
  directionCD = _GDirectionCD;
  mediump vec2 xzVtx;
  xzVtx = vtxForAni.xz;
  mediump vec3 offsets_i0;
  mediump vec4 TIME;
  mediump vec4 tmpvar_5;
  tmpvar_5 = ((steepness.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_6;
  tmpvar_6 = ((steepness.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_7;
  tmpvar_7.x = dot (directionAB.xy, xzVtx);
  tmpvar_7.y = dot (directionAB.zw, xzVtx);
  tmpvar_7.z = dot (directionCD.xy, xzVtx);
  tmpvar_7.w = dot (directionCD.zw, xzVtx);
  mediump vec4 tmpvar_8;
  tmpvar_8 = (frequency * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Time.yyyy * speed);
  TIME = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = cos ((tmpvar_8 + TIME));
  mediump vec4 tmpvar_11;
  tmpvar_11.xy = tmpvar_5.xz;
  tmpvar_11.zw = tmpvar_6.xz;
  offsets_i0.x = dot (tmpvar_10, tmpvar_11);
  mediump vec4 tmpvar_12;
  tmpvar_12.xy = tmpvar_5.yw;
  tmpvar_12.zw = tmpvar_6.yw;
  offsets_i0.z = dot (tmpvar_10, tmpvar_12);
  offsets_i0.y = dot (sin ((tmpvar_8 + TIME)), amplitude);
  mediump vec2 xzVtx_i0;
  xzVtx_i0 = (vtxForAni.xz + offsets_i0.xz);
  mediump vec4 TIME_i0;
  mediump vec3 nrml_i0_i0;
  nrml_i0_i0 = vec3(0.0, 2.0, 0.0);
  mediump vec4 tmpvar_13;
  tmpvar_13 = ((frequency.xxyy * amplitude.xxyy) * directionAB);
  mediump vec4 tmpvar_14;
  tmpvar_14 = ((frequency.zzww * amplitude.zzww) * directionCD);
  mediump vec4 tmpvar_15;
  tmpvar_15.x = dot (directionAB.xy, xzVtx_i0);
  tmpvar_15.y = dot (directionAB.zw, xzVtx_i0);
  tmpvar_15.z = dot (directionCD.xy, xzVtx_i0);
  tmpvar_15.w = dot (directionCD.zw, xzVtx_i0);
  highp vec4 tmpvar_16;
  tmpvar_16 = (_Time.yyyy * speed);
  TIME_i0 = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = cos (((frequency * tmpvar_15) + TIME_i0));
  mediump vec4 tmpvar_18;
  tmpvar_18.xy = tmpvar_13.xz;
  tmpvar_18.zw = tmpvar_14.xz;
  nrml_i0_i0.x = -(dot (tmpvar_17, tmpvar_18));
  mediump vec4 tmpvar_19;
  tmpvar_19.xy = tmpvar_13.yw;
  tmpvar_19.zw = tmpvar_14.yw;
  nrml_i0_i0.z = -(dot (tmpvar_17, tmpvar_19));
  nrml_i0_i0.xz = (nrml_i0_i0.xz * _GerstnerIntensity);
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize (nrml_i0_i0);
  nrml_i0_i0 = tmpvar_20;
  tmpvar_1.xyz = (_glesVertex.xyz + offsets_i0);
  highp vec2 tmpvar_21;
  tmpvar_21 = (_Object2World * tmpvar_1).xz;
  tileableUv = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  highp vec4 o_i0;
  highp vec4 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * 0.5);
  o_i0 = tmpvar_23;
  highp vec2 tmpvar_24;
  tmpvar_24.x = tmpvar_23.x;
  tmpvar_24.y = (tmpvar_23.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_24 + tmpvar_23.w);
  o_i0.zw = tmpvar_22.zw;
  tmpvar_2.xyz = tmpvar_20;
  tmpvar_2.w = 1.0;
  gl_Position = tmpvar_22;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_7;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_8;
  tmpvar_8 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_9;
  tmpvar_9 = vec4(clamp ((tmpvar_8 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_10;
  tmpvar_10 = mix (baseColor, _ReflectionColor, tmpvar_9);
  baseColor = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_11;
  baseColor.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_i0;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_5;
  tmpvar_5 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((tmpvar_5 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = (clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_5), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
mov o4.zw, r0
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.yzyz
mul o3, r1, c12
add o2.xyz, r0, -c11
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = depth;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_11;
  highp vec2 tmpvar_12;
  tmpvar_12 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_12;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_13;
  tmpvar_13 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_14;
  tmpvar_14 = vec4(clamp ((tmpvar_13 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_15;
  tmpvar_15 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_14);
  baseColor = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_16;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_13), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_10;
  highp float tmpvar_11;
  highp float z;
  z = depth;
  tmpvar_11 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_11;
  highp vec2 tmpvar_12;
  tmpvar_12 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_12;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_13;
  tmpvar_13 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_14;
  tmpvar_14 = vec4(clamp ((tmpvar_13 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_15;
  tmpvar_15 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_14);
  baseColor = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_16;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_13), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_i0;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _ZBufferParams;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform vec4 _InvFadeParemeter;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_4;
  tmpvar_4 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, _ReflectionColor, vec4(clamp ((tmpvar_4 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = (clamp ((_InvFadeParemeter * (1.0/(((_ZBufferParams.z * texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x) + _ZBufferParams.w)) - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_4), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
mov o4.zw, r0
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.yzyz
mul o3, r1, c12
add o2.xyz, r0, -c11
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_7;
  highp float tmpvar_8;
  highp float z;
  z = depth;
  tmpvar_8 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_10;
  tmpvar_10 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = vec4(clamp ((tmpvar_10 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_12;
  tmpvar_12 = mix (baseColor, _ReflectionColor, tmpvar_11);
  baseColor = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_13;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_10), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp vec4 _InvFadeParemeter;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _CameraDepthTexture;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  mediump float depth;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD3).x;
  depth = tmpvar_7;
  highp float tmpvar_8;
  highp float z;
  z = depth;
  tmpvar_8 = 1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w));
  depth = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_9;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_10;
  tmpvar_10 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_11;
  tmpvar_11 = vec4(clamp ((tmpvar_10 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_12;
  tmpvar_12 = mix (baseColor, _ReflectionColor, tmpvar_11);
  baseColor = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_13;
  baseColor.w = (clamp ((_InvFadeParemeter * (depth - xlv_TEXCOORD3.z)), 0.0, 1.0).x * clamp ((0.5 + tmpvar_10), 0.0, 1.0));
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_i0;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform sampler2D _ReflectionTex;
uniform vec4 _ReflectionColor;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.xy = ((tmpvar_2.xz * _DistortParams.y) * 10.0);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_5;
  tmpvar_5 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, mix (texture2DProj (_ReflectionTex, (xlv_TEXCOORD3 + tmpvar_4)), _ReflectionColor, _ReflectionColor.wwww), vec4(clamp ((tmpvar_5 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = clamp ((0.5 + tmpvar_5), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
mov o4.zw, r0
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.yzyz
mul o3, r1, c12
add o2.xyz, r0, -c11
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_10;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_11;
  tmpvar_11 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_12;
  tmpvar_12 = vec4(clamp ((tmpvar_11 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_12);
  baseColor = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_14;
  baseColor.w = clamp ((0.5 + tmpvar_11), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform sampler2D _ReflectionTex;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec4 rtReflections;
  mediump vec4 screenWithOffset;
  mediump vec4 distortOffset;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.0, 0.0);
  tmpvar_5.xy = ((tmpvar_3.xz * _DistortParams.y) * 10.0);
  distortOffset = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD3 + distortOffset);
  screenWithOffset = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ReflectionTex, screenWithOffset);
  rtReflections = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_10;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_11;
  tmpvar_11 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_12;
  tmpvar_12 = vec4(clamp ((tmpvar_11 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_13;
  tmpvar_13 = mix (baseColor, mix (rtReflections, _ReflectionColor, _ReflectionColor.wwww), tmpvar_12);
  baseColor = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_14;
  baseColor.w = clamp ((0.5 + tmpvar_11), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;

uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _Time;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _BumpTiling;
uniform vec4 _BumpDirection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_i0;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((_Object2World * gl_Vertex).xyz - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = (((_Object2World * gl_Vertex).xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD2;
varying vec3 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform vec4 _WorldLightDir;
uniform vec4 _SpecularColor;
uniform float _Shininess;
uniform vec4 _ReflectionColor;
uniform float _FresnelScale;
uniform vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform vec4 _BaseColor;
void main ()
{
  vec4 baseColor;
  vec3 worldNormal;
  vec4 bump;
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, xlv_TEXCOORD2.xy) + texture2D (_BumpMap, xlv_TEXCOORD2.zw));
  bump = tmpvar_1;
  bump.xy = (tmpvar_1.wy - vec2(1.0, 1.0));
  vec3 tmpvar_2;
  tmpvar_2 = normalize ((normalize (xlv_TEXCOORD0.xyz) + ((bump.xxy * _DistortParams.x) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  worldNormal.xz = (tmpvar_2.xz * _FresnelScale);
  float tmpvar_4;
  tmpvar_4 = clamp ((_DistortParams.w + ((1.0 - _DistortParams.w) * pow (clamp ((1.0 - max (dot (-(tmpvar_3), worldNormal), 0.0)), 0.0, 1.0), _DistortParams.z))), 0.0, 1.0);
  baseColor = (mix (_BaseColor, _ReflectionColor, vec4(clamp ((tmpvar_4 * 2.0), 0.0, 1.0))) + (max (0.0, pow (max (0.0, dot (tmpvar_2, -(normalize ((_WorldLightDir.xyz + tmpvar_3))))), _Shininess)) * _SpecularColor));
  baseColor.w = clamp ((0.5 + tmpvar_4), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_ProjectionParams]
Vector 10 [_ScreenParams]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [_BumpTiling]
Vector 13 [_BumpDirection]
"vs_3_0
; 18 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c14, 0.50000000, 0.00000000, 1.00000000, 0
dcl_position0 v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c14.x
mov o0, r0
mul r1.y, r1, c9.x
mad o4.xy, r1.z, c10.zwzw, r1
dp4 r0.y, v0, c6
mov o4.zw, r0
dp4 r0.x, v0, c4
mov r1.x, c8
mad r1, c13, r1.x, r0.xyxy
mov r0.z, r0.y
dp4 r0.y, v0, c5
mov o1, c14.yzyz
mul o3, r1, c12
add o2.xyz, r0, -c11
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_7;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_8;
  tmpvar_8 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_9;
  tmpvar_9 = vec4(clamp ((tmpvar_8 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_10;
  tmpvar_10 = mix (baseColor, _ReflectionColor, tmpvar_9);
  baseColor = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_11;
  baseColor.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec2 tileableUv;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = (_Object2World * _glesVertex).xz;
  tileableUv = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * 0.5);
  o_i0 = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_6 + tmpvar_5.w);
  o_i0.zw = tmpvar_4.zw;
  tmpvar_1.xyz = vec3(0.0, 1.0, 0.0);
  tmpvar_1.w = 1.0;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (worldSpaceVertex - _WorldSpaceCameraPos);
  xlv_TEXCOORD2 = ((tileableUv.xyxy + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  highp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD0.xyz);
  mediump vec4 coords;
  coords = xlv_TEXCOORD2;
  mediump vec3 vertexNormal;
  vertexNormal = tmpvar_1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_2;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_3;
  tmpvar_3 = normalize ((vertexNormal + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize (xlv_TEXCOORD1);
  viewVector = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = max (0.0, dot (tmpvar_3, -(h)));
  nh = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (tmpvar_3.xz * _FresnelScale);
  worldNormal.xz = tmpvar_7;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_8;
  tmpvar_8 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_9;
  tmpvar_9 = vec4(clamp ((tmpvar_8 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_10;
  tmpvar_10 = mix (baseColor, _ReflectionColor, tmpvar_9);
  baseColor = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (baseColor + (max (0.0, pow (nh, _Shininess)) * _SpecularColor));
  baseColor = tmpvar_11;
  baseColor.w = clamp ((0.5 + tmpvar_8), 0.0, 1.0);
  gl_FragData[0] = baseColor;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   d3d9 - ALU: 42 to 52, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"ps_3_0
; 52 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 2.00000000, 10.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.z, v0, v0
texld r0.yw, v2, s0
texld r1.yw, v2.zwzw, s0
add r0.xy, r0.ywzw, r1.ywzw
rsq r0.z, r0.z
add_pp r0.xy, r0.yxzw, c9.z
mul r1.xyz, r0.z, v0
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.xyxw, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c9.y
mul r0.xy, r0, c10.y
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r1.xyz, -r0, c3
mad_pp r1.xyz, r1, c3.w, r0
dp3 r0.w, v1, v1
rsq r0.x, r0.w
add_pp r4.xyz, r1, -c2
mul r1.xyz, r0.x, v1
add r3.xyz, r1, c6
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r0.x, -r1, r0
dp3 r0.w, r3, r3
rsq r0.y, r0.w
max_pp r0.w, r0.x, c9.y
mul r0.xyz, r0.y, r3
dp3_pp r1.y, r2, -r0
add_pp_sat r1.x, -r0.w, c9
pow_pp r0, r1.x, c7.z
max_pp r1.x, r1.y, c9.y
mov_pp r0.z, r0.x
mov_pp r0.y, c7.w
add_pp r0.x, c9, -r0.y
mad_pp_sat r1.y, r0.x, r0.z, c7.w
pow r0, r1.x, c5.x
mul_pp_sat r0.y, r1, c10.x
mad_pp r2.xyz, r0.y, r4, c2
mov r0.y, r0.x
max r0.y, r0, c9
texldp r1.x, v3, s2
mad r0.x, r1, c0.z, c0.w
rcp r0.x, r0.x
mad oC0.xyz, r0.y, c1, r2
add r0.x, r0, -v3.z
add_pp_sat r0.y, r1, c9.w
mul_sat r0.x, r0, c4
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
"ps_3_0
; 46 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.z
mul_pp r3.xy, r0, c7.x
dp3 r0.y, v0, v0
rsq r0.w, r0.y
mul r1.xyz, r0.w, v0
mad_pp r1.xyz, r3.xxyw, c9.xyxw, r1
dp3_pp r0.w, r1, r1
rsq_pp r0.w, r0.w
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
add r2.xyz, r0, c6
dp3 r1.w, r2, r2
rsq r1.w, r1.w
mul_pp r1.xyz, r0.w, r1
mul r2.xyz, r1.w, r2
dp3_pp r0.w, r1, -r2
mul_pp r1.xz, r1, c8.x
dp3_pp r0.x, -r0, r1
max_pp r1.y, r0.w, c9
max_pp r1.x, r0, c9.y
pow r0, r1.y, c5.x
add_pp_sat r0.y, -r1.x, c9.x
mov r0.z, r0.x
pow_pp r1, r0.y, c7.z
mov_pp r0.y, r1.x
mov_pp r0.x, c7.w
add_pp r0.x, c9, -r0
mad_pp_sat r0.y, r0.x, r0, c7.w
mul_pp_sat r0.w, r0.y, c10.x
mov_pp r1.xyz, c3
texldp r0.x, v3, s1
add_pp r1.xyz, -c2, r1
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.x, r0, -v3.z
max r0.z, r0, c9.y
mad_pp r1.xyz, r0.w, r1, c2
add_pp_sat r0.y, r0, c9.w
mul_sat r0.x, r0, c4
mad oC0.xyz, r0.z, c1, r1
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
"ps_3_0
; 46 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 2.00000000, 10.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.z, v0, v0
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
rsq r0.z, r0.z
add_pp r0.xy, r0.yxzw, c7.z
mul r1.xyz, r0.z, v0
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c5.y
dp3 r1.x, v1, v1
mov_pp r0.zw, c7.y
mul r0.xy, r0, c8.y
add r0, v3, r0
texldp r0.xyz, r0, s1
rsq r0.w, r1.x
add_pp r3.xyz, -r0, c2
mad_pp r0.xyz, r3, c2.w, r0
mul r1.xyz, r0.w, v1
add_pp r4.xyz, r0, -c1
add r3.xyz, r1, c4
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c6.x
mov_pp r0.y, r2
dp3_pp r0.x, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.y, r2, -r3
max_pp r0.x, r0, c7.y
max_pp r1.x, r0.y, c7.y
add_pp_sat r2.x, -r0, c7
pow r0, r1.x, c3.x
pow_pp r1, r2.x, c5.z
mov_pp r0.y, c5.w
mov_pp r0.z, r1.x
add_pp r0.y, c7.x, -r0
mad_pp_sat r0.y, r0, r0.z, c5.w
mul_pp_sat r0.z, r0.y, c8.x
mad_pp r1.xyz, r0.z, r4, c1
max r0.x, r0, c7.y
mad oC0.xyz, r0.x, c0, r1
add_pp_sat oC0.w, r0.y, c7
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"ps_3_0
; 42 ALU, 2 TEX
dcl_2d s0
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dp3 r0.z, v0, v0
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
rsq r0.z, r0.z
add_pp r0.xy, r0.yxzw, c7.z
dp3 r0.w, v1, v1
mul r1.xyz, r0.z, v0
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
dp3_pp r1.w, r0, r0
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, r0
add r3.xyz, r1, c4
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c6.x
mov_pp r0.y, r2
dp3_pp r0.x, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.y, r2, -r3
max_pp r0.x, r0, c7.y
max_pp r1.x, r0.y, c7.y
add_pp_sat r2.x, -r0, c7
pow r0, r1.x, c3.x
pow_pp r1, r2.x, c5.z
mov_pp r0.y, r1.x
mov r0.z, r0.x
mov_pp r0.x, c5.w
mov_pp r1.xyz, c2
add_pp r0.x, c7, -r0
mad_pp_sat r0.x, r0, r0.y, c5.w
mul_pp_sat r0.y, r0.x, c8.x
add_pp r1.xyz, -c1, r1
mad_pp r1.xyz, r0.y, r1, c1
max r0.y, r0.z, c7
mad oC0.xyz, r0.y, c0, r1
add_pp_sat oC0.w, r0.x, c7
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_ON" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
SetTexture 2 [_CameraDepthTexture] 2D
"ps_3_0
; 52 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 2.00000000, 10.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.z, v0, v0
texld r0.yw, v2, s0
texld r1.yw, v2.zwzw, s0
add r0.xy, r0.ywzw, r1.ywzw
rsq r0.z, r0.z
add_pp r0.xy, r0.yxzw, c9.z
mul r1.xyz, r0.z, v0
mul_pp r0.xy, r0, c7.x
mad_pp r0.xyz, r0.xxyw, c9.xyxw, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c7.y
mov_pp r0.zw, c9.y
mul r0.xy, r0, c10.y
add r0, v3, r0
texldp r0.xyz, r0, s1
add_pp r1.xyz, -r0, c3
mad_pp r1.xyz, r1, c3.w, r0
dp3 r0.w, v1, v1
rsq r0.x, r0.w
add_pp r4.xyz, r1, -c2
mul r1.xyz, r0.x, v1
add r3.xyz, r1, c6
mul_pp r0.xz, r2, c8.x
mov_pp r0.y, r2
dp3_pp r0.x, -r1, r0
dp3 r0.w, r3, r3
rsq r0.y, r0.w
max_pp r0.w, r0.x, c9.y
mul r0.xyz, r0.y, r3
dp3_pp r1.y, r2, -r0
add_pp_sat r1.x, -r0.w, c9
pow_pp r0, r1.x, c7.z
max_pp r1.x, r1.y, c9.y
mov_pp r0.z, r0.x
mov_pp r0.y, c7.w
add_pp r0.x, c9, -r0.y
mad_pp_sat r1.y, r0.x, r0.z, c7.w
pow r0, r1.x, c5.x
mul_pp_sat r0.y, r1, c10.x
mad_pp r2.xyz, r0.y, r4, c2
mov r0.y, r0.x
max r0.y, r0, c9
texldp r1.x, v3, s2
mad r0.x, r1, c0.z, c0.w
rcp r0.x, r0.x
mad oC0.xyz, r0.y, c1, r2
add r0.x, r0, -v3.z
add_pp_sat r0.y, r1, c9.w
mul_sat r0.x, r0, c4
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
Vector 0 [_ZBufferParams]
Vector 1 [_SpecularColor]
Vector 2 [_BaseColor]
Vector 3 [_ReflectionColor]
Vector 4 [_InvFadeParemeter]
Float 5 [_Shininess]
Vector 6 [_WorldLightDir]
Vector 7 [_DistortParams]
Float 8 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_CameraDepthTexture] 2D
"ps_3_0
; 46 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c9, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c10, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
add_pp r0.xy, r0.yxzw, c9.z
mul_pp r3.xy, r0, c7.x
dp3 r0.y, v0, v0
rsq r0.w, r0.y
mul r1.xyz, r0.w, v0
mad_pp r1.xyz, r3.xxyw, c9.xyxw, r1
dp3_pp r0.w, r1, r1
rsq_pp r0.w, r0.w
dp3 r0.x, v1, v1
rsq r0.x, r0.x
mul r0.xyz, r0.x, v1
add r2.xyz, r0, c6
dp3 r1.w, r2, r2
rsq r1.w, r1.w
mul_pp r1.xyz, r0.w, r1
mul r2.xyz, r1.w, r2
dp3_pp r0.w, r1, -r2
mul_pp r1.xz, r1, c8.x
dp3_pp r0.x, -r0, r1
max_pp r1.y, r0.w, c9
max_pp r1.x, r0, c9.y
pow r0, r1.y, c5.x
add_pp_sat r0.y, -r1.x, c9.x
mov r0.z, r0.x
pow_pp r1, r0.y, c7.z
mov_pp r0.y, r1.x
mov_pp r0.x, c7.w
add_pp r0.x, c9, -r0
mad_pp_sat r0.y, r0.x, r0, c7.w
mul_pp_sat r0.w, r0.y, c10.x
mov_pp r1.xyz, c3
texldp r0.x, v3, s1
add_pp r1.xyz, -c2, r1
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.x, r0, -v3.z
max r0.z, r0, c9.y
mad_pp r1.xyz, r0.w, r1, c2
add_pp_sat r0.y, r0, c9.w
mul_sat r0.x, r0, c4
mad oC0.xyz, r0.z, c1, r1
mul_pp oC0.w, r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_ON" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ReflectionTex] 2D
"ps_3_0
; 46 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 2.00000000, 10.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dcl_texcoord3 v3
dp3 r0.z, v0, v0
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
rsq r0.z, r0.z
add_pp r0.xy, r0.yxzw, c7.z
mul r1.xyz, r0.z, v0
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, r1
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r0
mul r0.xy, r2.xzzw, c5.y
dp3 r1.x, v1, v1
mov_pp r0.zw, c7.y
mul r0.xy, r0, c8.y
add r0, v3, r0
texldp r0.xyz, r0, s1
rsq r0.w, r1.x
add_pp r3.xyz, -r0, c2
mad_pp r0.xyz, r3, c2.w, r0
mul r1.xyz, r0.w, v1
add_pp r4.xyz, r0, -c1
add r3.xyz, r1, c4
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c6.x
mov_pp r0.y, r2
dp3_pp r0.x, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.y, r2, -r3
max_pp r0.x, r0, c7.y
max_pp r1.x, r0.y, c7.y
add_pp_sat r2.x, -r0, c7
pow r0, r1.x, c3.x
pow_pp r1, r2.x, c5.z
mov_pp r0.y, c5.w
mov_pp r0.z, r1.x
add_pp r0.y, c7.x, -r0
mad_pp_sat r0.y, r0, r0.z, c5.w
mul_pp_sat r0.z, r0.y, c8.x
mad_pp r1.xyz, r0.z, r4, c1
max r0.x, r0, c7.y
mad oC0.xyz, r0.x, c0, r1
add_pp_sat oC0.w, r0.y, c7
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_REFLECTIVE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"ps_3_0
; 42 ALU, 2 TEX
dcl_2d s0
def c7, 1.00000000, 0.00000000, -1.00000000, 0.50000000
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2
dp3 r0.z, v0, v0
texld r1.yw, v2.zwzw, s0
texld r0.yw, v2, s0
add r0.xy, r0.ywzw, r1.ywzw
rsq r0.z, r0.z
add_pp r0.xy, r0.yxzw, c7.z
dp3 r0.w, v1, v1
mul r1.xyz, r0.z, v0
mul_pp r0.xy, r0, c5.x
mad_pp r0.xyz, r0.xxyw, c7.xyxw, r1
rsq r0.w, r0.w
mul r1.xyz, r0.w, v1
dp3_pp r1.w, r0, r0
rsq_pp r0.w, r1.w
mul_pp r2.xyz, r0.w, r0
add r3.xyz, r1, c4
dp3 r0.y, r3, r3
rsq r0.w, r0.y
mul_pp r0.xz, r2, c6.x
mov_pp r0.y, r2
dp3_pp r0.x, -r1, r0
mul r3.xyz, r0.w, r3
dp3_pp r0.y, r2, -r3
max_pp r0.x, r0, c7.y
max_pp r1.x, r0.y, c7.y
add_pp_sat r2.x, -r0, c7
pow r0, r1.x, c3.x
pow_pp r1, r2.x, c5.z
mov_pp r0.y, r1.x
mov r0.z, r0.x
mov_pp r0.x, c5.w
mov_pp r1.xyz, c2
add_pp r0.x, c7, -r0
mad_pp_sat r0.x, r0, r0.y, c5.w
mul_pp_sat r0.y, r0.x, c8.x
add_pp r1.xyz, -c1, r1
mad_pp r1.xyz, r0.y, r1, c1
max r0.y, r0.z, c7
mad oC0.xyz, r0.y, c0, r1
add_pp_sat oC0.w, r0.x, c7
"
}

SubProgram "gles " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "WATER_VERTEX_DISPLACEMENT_OFF" "WATER_EDGEBLEND_OFF" "WATER_SIMPLE" }
"!!GLES"
}

}

#LINE 416

	}	
}

Subshader 
{ 	
	Tags {"RenderType"="Transparent" "Queue"="Transparent"}
	
	Lod 200
	ColorMask RGB
	
	Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 12 to 12
//   d3d9 - ALU: 12 to 12
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Vector 9 [_Time]
Vector 10 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 11 [_BumpTiling]
Vector 12 [_BumpDirection]
"!!ARBvp1.0
# 12 ALU
PARAM c[13] = { { 1 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
MOV R1, c[12];
MAD R1, R1, c[9].x, R0.xzxz;
DP4 R0.y, vertex.position, c[6];
MUL result.texcoord[1], R1, c[11];
ADD result.texcoord[0].xyz, R0, -c[10];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MOV result.texcoord[0].w, c[0].x;
END
# 12 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_Time]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [_BumpTiling]
Vector 11 [_BumpDirection]
"vs_2_0
; 12 ALU
def c12, 1.00000000, 0, 0, 0
dcl_position0 v0
mov r0.y, c8.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
mad r1, c11, r0.y, r0.xzxz
dp4 r0.y, v0, c5
mul oT1, r1, c10
add oT0.xyz, r0, -c9
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT0.w, c12.x
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  tmpvar_1.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  tmpvar_1.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((worldSpaceVertex.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vec3(0.0, 1.0, 0.0) + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD0.xyz);
  viewVector = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_4;
  mediump float tmpvar_5;
  tmpvar_5 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_6;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_7;
  tmpvar_7 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_8;
  tmpvar_8 = vec4(clamp ((tmpvar_7 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_9;
  tmpvar_9 = mix (baseColor, _ReflectionColor, tmpvar_8);
  baseColor = tmpvar_9;
  baseColor.w = clamp (((2.0 * tmpvar_7) + 0.5), 0.0, 1.0);
  highp vec3 tmpvar_10;
  tmpvar_10 = (baseColor.xyz + (max (0.0, pow (nh, _Shininess)) * _SpecularColor.xyz));
  baseColor.xyz = tmpvar_10;
  gl_FragData[0] = baseColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _Time;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpTiling;
uniform highp vec4 _BumpDirection;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mediump vec3 worldSpaceVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = (_Object2World * _glesVertex).xyz;
  worldSpaceVertex = tmpvar_2;
  tmpvar_1.xyz = (worldSpaceVertex - _WorldSpaceCameraPos);
  tmpvar_1.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = ((worldSpaceVertex.xzxz + (_Time.xxxx * _BumpDirection)) * _BumpTiling);
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _WorldLightDir;
uniform highp vec4 _SpecularColor;
uniform highp float _Shininess;
uniform highp vec4 _ReflectionColor;
uniform highp float _FresnelScale;
uniform highp vec4 _DistortParams;
uniform sampler2D _BumpMap;
uniform highp vec4 _BaseColor;
void main ()
{
  mediump vec4 baseColor;
  highp float nh;
  mediump vec3 h;
  mediump vec3 viewVector;
  mediump vec3 worldNormal;
  mediump vec4 coords;
  coords = xlv_TEXCOORD1;
  mediump float bumpStrength;
  bumpStrength = _DistortParams.x;
  mediump vec4 bump;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_BumpMap, coords.xy) + texture2D (_BumpMap, coords.zw));
  bump = tmpvar_1;
  bump.xy = (bump.wy - vec2(1.0, 1.0));
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize ((vec3(0.0, 1.0, 0.0) + ((bump.xxy * bumpStrength) * vec3(1.0, 0.0, 1.0))));
  worldNormal = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD0.xyz);
  viewVector = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldLightDir.xyz + viewVector));
  h = tmpvar_4;
  mediump float tmpvar_5;
  tmpvar_5 = max (0.0, dot (tmpvar_2, -(h)));
  nh = tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (tmpvar_2.xz * _FresnelScale);
  worldNormal.xz = tmpvar_6;
  mediump float bias;
  bias = _DistortParams.w;
  mediump float power;
  power = _DistortParams.z;
  float tmpvar_7;
  tmpvar_7 = clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewVector), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0);
  baseColor = _BaseColor;
  mediump vec4 tmpvar_8;
  tmpvar_8 = vec4(clamp ((tmpvar_7 * 2.0), 0.0, 1.0));
  highp vec4 tmpvar_9;
  tmpvar_9 = mix (baseColor, _ReflectionColor, tmpvar_8);
  baseColor = tmpvar_9;
  baseColor.w = clamp (((2.0 * tmpvar_7) + 0.5), 0.0, 1.0);
  highp vec3 tmpvar_10;
  tmpvar_10 = (baseColor.xyz + (max (0.0, pow (nh, _Shininess)) * _SpecularColor.xyz));
  baseColor.xyz = tmpvar_10;
  gl_FragData[0] = baseColor;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 35 to 35, TEX: 2 to 2
//   d3d9 - ALU: 51 to 51, TEX: 2 to 2
SubProgram "opengl " {
Keywords { }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 2 TEX
PARAM c[8] = { program.local[0..6],
		{ 1, 0, 2, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.yw, fragment.texcoord[1].zwzw, texture[0], 2D;
TEX R0.yw, fragment.texcoord[1], texture[0], 2D;
ADD R0.zw, R0.xyyw, R1.xyyw;
ADD R1.xy, R0.wzzw, -c[7].x;
DP3 R0.x, fragment.texcoord[0], fragment.texcoord[0];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[0];
ADD R2.xyz, R0, c[4];
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R1.xy, R1, c[5].x;
MAD R1.xyz, R1.xxyw, c[7].xyxw, c[7].yxyw;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
MUL R2.xyz, R1.w, R2;
DP3 R0.w, R1, -R2;
MUL R1.xz, R1, c[6].x;
DP3 R0.x, -R0, R1;
MAX R0.w, R0, c[7].y;
POW R0.y, R0.w, c[3].x;
MAX R0.x, R0, c[7].y;
ADD_SAT R0.w, -R0.x, c[7].x;
POW R1.w, R0.w, c[5].z;
MAX R0.y, R0, c[7];
MOV R0.w, c[7].x;
MOV R1.xyz, c[1];
ADD R0.w, R0, -c[5];
MAD_SAT R0.w, R0, R1, c[5];
MUL R0.xyz, R0.y, c[0];
ADD R1.xyz, -R1, c[2];
MUL_SAT R1.w, R0, c[7].z;
MAD R1.xyz, R1.w, R1, c[1];
ADD result.color.xyz, R1, R0;
MAD_SAT result.color.w, R0, c[7].z, c[7];
END
# 35 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_SpecularColor]
Vector 1 [_BaseColor]
Vector 2 [_ReflectionColor]
Float 3 [_Shininess]
Vector 4 [_WorldLightDir]
Vector 5 [_DistortParams]
Float 6 [_FresnelScale]
SetTexture 0 [_BumpMap] 2D
"ps_2_0
; 51 ALU, 2 TEX
dcl_2d s0
def c7, 1.00000000, 0.00000000, -1.00000000, 2.00000000
def c8, 2.00000000, 0.50000000, 0, 0
dcl t0.xyz
dcl t1
texld r1, t1, s0
mov r0.y, t1.w
mov r0.x, t1.z
mov r1.xz, c7.x
texld r0, r0, s0
add r0.yw, r1, r0
mov r0.x, r0.w
add_pp r0.xy, r0, c7.z
mov_pp r0.z, r0.y
mul_pp r0.xz, r0, c5.x
mov_pp r2.xy, r0.x
mov_pp r2.z, r0
mov r0.xz, c7.y
mov r0.y, c7.x
mov r1.y, c7
mad_pp r1.xyz, r2, r1, r0
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, r1
dp3 r0.x, t0, t0
rsq r0.x, r0.x
mul r3.xyz, r0.x, t0
mul_pp r1.xz, r2, c6.x
mov_pp r1.y, r2
dp3_pp r0.x, -r3, r1
add r4.xyz, r3, c4
max_pp r0.x, r0, c7.y
add_pp_sat r0.x, -r0, c7
pow_pp r3.x, r0.x, c5.z
dp3 r1.x, r4, r4
rsq r0.x, r1.x
mul r1.xyz, r0.x, r4
dp3_pp r1.x, r2, -r1
mov_pp r0.w, c5
add_pp r2.x, c7, -r0.w
mov_pp r0.x, r3.x
mad_pp_sat r0.x, r2, r0, c5.w
max_pp r1.x, r1, c7.y
pow r2.x, r1.x, c3.x
mad_pp_sat r0.w, r0.x, c8.x, c8.y
mov r1.x, r2.x
mov_pp r2.xyz, c2
max r1.x, r1, c7.y
mul_pp_sat r0.x, r0, c7.w
add_pp r2.xyz, -c1, r2
mul r1.xyz, r1.x, c0
mad_pp r0.xyz, r0.x, r2, c1
add_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

}

#LINE 439

	}	
}

Fallback "Transparent/Diffuse"
}
