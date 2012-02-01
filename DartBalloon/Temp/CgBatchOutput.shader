// Per pixel bumped refraction.
// Uses a normal map to distort the image behind, and
// an additional texture to tint the color.

Shader "HeatDistort" {
Properties {
	_BumpAmt  ("Distortion", range (0,128)) = 10
	_MainTex ("Tint Color (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

#LINE 43


Category {

	// We must be transparent, so other objects are drawn before this one.
	Tags { "Queue"="Transparent+100" "RenderType"="Opaque" }


	SubShader {

		// This pass grabs the screen behind the object into a texture.
		// We can access the result in the next pass as _GrabTexture
		GrabPass {							
			Name "BASE"
			Tags { "LightMode" = "Always" }
 		}
 		
 		// Main pass: Take the texture grabbed above and use the bumpmap to perturb it
 		// on to the screen
		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 17 to 17
//   d3d9 - ALU: 18 to 18
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
"!!ARBvp1.0
# 17 ALU
PARAM c[13] = { { 0, 0.5 },
		state.matrix.mvp,
		state.matrix.texture[1],
		state.matrix.texture[2] };
TEMP R0;
TEMP R1;
DP4 R1.z, vertex.position, c[4];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MOV R0.w, R1.z;
DP4 R0.z, vertex.position, c[3];
MOV R0.x, R1;
MOV R0.y, R1;
MOV result.position, R0;
MOV result.texcoord[0].zw, R0;
ADD R1.xy, R1.z, R1;
MOV R0.zw, c[0].x;
MOV R0.xy, vertex.texcoord[0];
DP4 result.texcoord[1].y, R0, c[6];
DP4 result.texcoord[1].x, R0, c[5];
DP4 result.texcoord[2].y, R0, c[10];
DP4 result.texcoord[2].x, R0, c[9];
MUL result.texcoord[0].xy, R1, c[0].y;
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture1]
Matrix 8 [glstate_matrix_texture2]
"vs_2_0
; 18 ALU
def c12, 0.50000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dp4 r1.z, v0, c3
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mov r0.y, r1
mov r0.w, r1.z
dp4 r0.z, v0, c2
mov r0.x, r1
mov oPos, r0
mov oT0.zw, r0
mov r1.y, -r1
add r1.xy, r1.z, r1
mov r0.zw, c12.y
mov r0.xy, v1
dp4 oT1.y, r0, c5
dp4 oT1.x, r0, c4
dp4 oT2.y, r0, c9
dp4 oT2.x, r0, c8
mul oT0.xy, r1, c12.x
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
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define gl_TextureMatrix2 glstate_matrix_texture2
uniform mat4 glstate_matrix_texture2;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;



attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1.xy = ((tmpvar_2.xy + tmpvar_2.w) * 0.5);
  tmpvar_1.zw = tmpvar_2.zw;
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.x = _glesMultiTexCoord0.x;
  tmpvar_3.y = _glesMultiTexCoord0.y;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.x = _glesMultiTexCoord0.x;
  tmpvar_4.y = _glesMultiTexCoord0.y;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (gl_TextureMatrix1 * tmpvar_3).xy;
  xlv_TEXCOORD2 = (gl_TextureMatrix2 * tmpvar_4).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform highp vec4 _GrabTexture_TexelSize;
uniform sampler2D _GrabTexture;
uniform sampler2D _BumpMap;
uniform highp float _BumpAmt;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  mediump vec4 tint;
  mediump vec4 col;
  mediump vec2 bump;
  lowp vec2 tmpvar_2;
  tmpvar_2 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0).xy;
  bump = tmpvar_2;
  tmpvar_1.xy = ((((bump * _BumpAmt) * _GrabTexture_TexelSize.xy) * xlv_TEXCOORD0.z) + xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1.xyw;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_GrabTexture, tmpvar_3);
  col = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD2);
  tint = tmpvar_5;
  gl_FragData[0] = (col * tint);
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
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define gl_TextureMatrix2 glstate_matrix_texture2
uniform mat4 glstate_matrix_texture2;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;



attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1.xy = ((tmpvar_2.xy + tmpvar_2.w) * 0.5);
  tmpvar_1.zw = tmpvar_2.zw;
  highp vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 0.0);
  tmpvar_3.x = _glesMultiTexCoord0.x;
  tmpvar_3.y = _glesMultiTexCoord0.y;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 0.0);
  tmpvar_4.x = _glesMultiTexCoord0.x;
  tmpvar_4.y = _glesMultiTexCoord0.y;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (gl_TextureMatrix1 * tmpvar_3).xy;
  xlv_TEXCOORD2 = (gl_TextureMatrix2 * tmpvar_4).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform highp vec4 _GrabTexture_TexelSize;
uniform sampler2D _GrabTexture;
uniform sampler2D _BumpMap;
uniform highp float _BumpAmt;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0;
  mediump vec4 tint;
  mediump vec4 col;
  mediump vec2 bump;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  lowp vec2 tmpvar_2;
  tmpvar_2 = normal.xy;
  bump = tmpvar_2;
  tmpvar_1.xy = ((((bump * _BumpAmt) * _GrabTexture_TexelSize.xy) * xlv_TEXCOORD0.z) + xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = tmpvar_1.xyw;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2DProj (_GrabTexture, tmpvar_3);
  col = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD2);
  tint = tmpvar_5;
  gl_FragData[0] = (col * tint);
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 9 to 9, TEX: 3 to 3
//   d3d9 - ALU: 8 to 8, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Vector 0 [_GrabTexture_TexelSize]
Float 1 [_BumpAmt]
SetTexture 0 [_GrabTexture] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
OPTION ARB_fog_exp2;
# 9 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1 } };
TEMP R0;
TEMP R1;
TEX R0.yw, fragment.texcoord[1], texture[1], 2D;
TEX R1, fragment.texcoord[2], texture[2], 2D;
MAD R0.xy, R0.wyzw, c[2].x, -c[2].y;
MUL R0.xy, R0, c[1].x;
MUL R0.xy, R0, c[0];
MAD R0.xy, R0, fragment.texcoord[0].z, fragment.texcoord[0];
MOV R0.z, fragment.texcoord[0].w;
TXP R0, R0.xyzz, texture[0], 2D;
MUL result.color, R0, R1;
END
# 9 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_GrabTexture_TexelSize]
Float 1 [_BumpAmt]
SetTexture 0 [_GrabTexture] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_MainTex] 2D
"ps_2_0
; 8 ALU, 3 TEX
dcl_2d s1
dcl_2d s0
dcl_2d s2
def c2, 2.00000000, -1.00000000, 0, 0
dcl t0
dcl t1.xy
dcl t2.xy
texld r0, t1, s1
mov r0.x, r0.w
mad_pp r0.xy, r0, c2.x, c2.y
mul r0.xy, r0, c1.x
mul r0.xy, r0, c0
mad r1.xy, r0, t0.z, t0
mov r1.w, t0
texld r0, t2, s2
texldp r1, r1, s0
mul_pp r0, r1, r0
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

#LINE 90

		}
	}

	// ------------------------------------------------------------------
	// Fallback for older cards and Unity non-Pro
	
	SubShader {
		Blend DstColor Zero
		Pass {
			Name "BASE"
			SetTexture [_MainTex] {	combine texture }
		}
	}
}

}
