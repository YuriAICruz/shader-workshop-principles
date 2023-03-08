Geometry Shaders

- Camera Rendering Path
  - Forward
    - A diferença entre ambos os passos é basicamente o memento em que a luz é calculada. No Forward Rendering a luz é computada a cada vertice e então interpolada a cada face [vertex lighting, vert] ou ela pode ser computada a cada pixel do shader interpolando as normais a cada face durante o calculo de luz [pixel lighting, frag]
  - Deferred
    - Ja no Deferred Rendering, toda a composição da camera é guardada em uma serie de buffers que vão guardar toda a informação necessaria para o calculo de luz, que só é feito no final, esse calculo é feito por pixel.

- cálculos customizados de luz
- a possibilidade de invocar uma geometria em um vértice
- tessellation
