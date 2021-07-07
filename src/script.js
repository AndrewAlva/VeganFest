import './style.css'
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import * as dat from 'dat.gui'
import testVertexShader from './shaders/test/vertex.glsl'
import testFragmentShader from './shaders/test/fragment.glsl'

/**
 * Base
 */
// Debug
const gui = new dat.GUI()
var parameters = {}
parameters.gridTiles = 23

// Canvas
const canvas = document.querySelector('canvas.webgl')

// Scene
const scene = new THREE.Scene()

/**
 * Test mesh
 */
// Geometry
const geometry = new THREE.PlaneGeometry(1, 1, 32, 32)

// Material
const material = new THREE.ShaderMaterial({
    vertexShader: testVertexShader,
    fragmentShader: testFragmentShader,
    side: THREE.DoubleSide,
    uniforms: {
        uGridTiles: { value: 23 },
        uNoiseSize: { value: 1 },
        uNoiseFrequency: { value: 9 },
        uNoiseAmplitude: { value: 1.05 },
        uKaleidoSections: { value: 2 },
        uAnimation: { value: 0 },
    }
})

gui.add(material.uniforms.uGridTiles, 'value').min(1).max(51).step(1).name('Grid tiles')
gui.add(material.uniforms.uNoiseSize, 'value').min(1).max(60).step(1).name('Perlin size')
gui.add(material.uniforms.uNoiseFrequency, 'value').min(1).max(150).step(1).name('Perlin frequency')
gui.add(material.uniforms.uNoiseAmplitude, 'value').min(1.05).max(10).step(0.01).name('min frequency')
gui.add(material.uniforms.uKaleidoSections, 'value').min(1).max(200).step(1).name('Kaleido sections')

// Mesh
const mesh = new THREE.Mesh(geometry, material)
scene.add(mesh)

/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})

/**
 * Camera
 */
// Base camera
const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height, 0.1, 100)
camera.position.set(0., - 0., .75)
scene.add(camera)

// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

/**
 * Animate
 */

const clock = new THREE.Clock();

const tick = () =>
{
    // Update controls
    controls.update()

    // Shader animations
    let elapsedTime = clock.getElapsedTime();
    // material.uniforms.uAnimation.value += Math.sin(elapsedTime * .7) * .25;
    material.uniforms.uAnimation.value = elapsedTime;

    // Render
    renderer.render(scene, camera)

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)
}

tick()