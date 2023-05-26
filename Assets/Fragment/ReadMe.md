Fragment Shaders

Também chamados de pixel shaders, é o processo responsavel por trazer a estetica do shader a tona.

- Fluxo
  - o CGPROGRAM funciona com base nos subprogramas de vertex e fragment
  - o subprograma de vertex sempre roda antes do subprogramas de fragment
- Dados da malha
  - todos os subprogramas recebem e retornam valores, que podem ser definidos no codigo
    - o subprograma de vertice deve devolver uma estrutura que será passada para o subprograma de fragment (pixel shader).
    - já o subprograma de fragment deve devolver a cor do pixel que será mostrada na tela ou aplicada na face do triando em questão.
  - esses dados são passados no passo anterior que é o passo de vertex.
  - UV
    - uv ou texture coordinate, é um dos principais dados que são fornecidos da malha, pois dele é possivel mapear uma textura de forma controlada.
  - Existem muitos mais dados que podem ser extraidos da malha, mas serão vistos com mais detalhes durante a materia de Vertex Shader
- Semanticas [[Doc ShaderLab](https://docs.unity3d.com/Manual/SL-Reference.html)]
  - Properties [[Cheat Sheet](https://gist.github.com/Split82/d1651403ffb05e912d9c3786f11d6a44)] [[Material Properties](https://github.com/YuriAICruz/Unity-ShaderLib/blob/master/Shaders/StandardRP/MaterialPropertyDrawer.shader)]
  - SubShader
    - [Tags](https://docs.unity3d.com/Manual/SL-SubShaderTags.html)
    - [LOD](https://docs.unity3d.com/Manual/SL-ShaderLOD.html)
  - vetores
    - float2 float3 e float4, são arrays com o tamanho descrito no fim do nome, eles podem ser acessado de diversas formas.
    - Exemplo o segundo indice de um float2.
      - value[1] ou value.y ou value.g
    - Exemplo retornar um float3 de um float4
      - float3(value[0], value[1], value[2]) ou value.xyz ou value.rgb
- Metodos
  - mapeamento de texturas
    - tex2D(sampler2D texture, float2 uv);
      - usado para devolver o valor de cor da textura na coordenada especficada
- bibliotecas
  - .cginc
    - funciona de uma forma bem parecida com .h em c++
    - pode ser adicionado com um #include
    - UnityCG.cginc
      - a grande maioria dos metodos que facilitam na hora de fazer calculos mais complexos como transformação de planos matriciais [local, world, camera clip, etc].
      - https://github.com/TwoTailsGames/Unity-Built-in-Shaders/blob/master/CGIncludes/UnityCG.cginc
