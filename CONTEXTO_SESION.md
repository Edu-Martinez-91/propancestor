# Contexto de sesión — propancestor

> Notas de trabajo para continuar en la próxima sesión. No es documentación
> de usuario (eso es `README.md` / `README.en.md`). No contiene credenciales.

## Situación general

- **GitHub**: repo público en https://github.com/Edu-Martinez-91/propancestor,
  recién creado a partir de un proyecto que ya estaba en producción.
- **Netlify**: ya existe un sitio en producción con `index.html` desplegado,
  pero ese despliegue tiene el **anon key real de Supabase embebido** (se
  subió a mano, sin conexión a este repo de GitHub).
- **Objetivo pendiente**: que los cambios de código se hagan en *un solo
  sitio* (este repo) y lleguen tanto a GitHub (con placeholders, sin
  credenciales) como a Netlify (con las credenciales reales), sin que la
  clave real toque nunca el repo ni su historial de git.

## Por qué no basta con `.gitignore`

`.gitignore` excluye **archivos completos**, no puede ocultar solo dos
líneas (`SUPABASE_URL` / `SUPABASE_ANON_KEY`) dentro de `index.html`. Por
eso no se puede tener "el mismo archivo" con datos reales en Netlify y con
placeholders en GitHub si se sube el mismo fichero a mano a los dos sitios.

## Solución propuesta (acordada, no implementada todavía)

Separar dónde vive el secreto (Netlify) de dónde vive el código (GitHub),
con sustitución en tiempo de build:

1. **Conectar el sitio de Netlify a este repo de GitHub** (Site settings →
   Build & deploy → Link site to Git) en vez de subir el HTML a mano. Así
   cada `git push` dispara un deploy automático.
2. En Netlify → **Site settings → Environment variables**, crear:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`

   con los valores reales. Quedan cifradas en Netlify, nunca en GitHub.
3. Añadir un `netlify.toml` en la raíz del repo (sin secretos, se sube tal
   cual) con un comando de build que sustituye los placeholders del
   `index.html` por esas variables de entorno **solo en el momento del
   despliegue**:

   ```toml
   [build]
     command = "sed -i -e \"s|TU_SUPABASE_URL_AQUI|$SUPABASE_URL|\" -e \"s|TU_SUPABASE_ANON_KEY_AQUI|$SUPABASE_ANON_KEY|\" index.html"
     publish = "."
   ```

   (Netlify corre en Linux/GNU sed — pendiente de probar el comando exacto
   antes de darlo por bueno; en macOS local `sed -i` necesita `''` como
   argumento extra, en GNU sed no).

**Resultado**: el repo público siempre tiene `TU_SUPABASE_URL_AQUI` /
`TU_SUPABASE_ANON_KEY_AQUI` (igual que ahora) → Netlify lo descarga →
sustituye con las credenciales reales solo en su copia desplegada → el
sitio en producción sigue sincronizando con el Supabase real, y la clave
nunca aparece en GitHub.

### Pendiente de hacer
- [ ] Decidir si Netlify se reconecta a este repo (perdiendo el deploy
      manual actual) — pendiente de confirmación del usuario.
- [ ] Crear `netlify.toml`.
- [ ] Verificar variables de entorno reales en el dashboard de Netlify.
- [ ] Primer deploy de prueba y confirmar que la sustitución funciona.

## Cambios ya hechos en esta sesión (commits en `master`, ya en GitHub)

1. **README bilingüe** (`README.md` ES + `README.en.md` EN), con selector
   de idioma y sección "¿Por qué propancestor?" (granularidad por pueblo,
   doble apellido, propagación a generaciones anteriores, calculador de
   rangos de edad, guía Registro Civil/Parroquia). Captura
   `docs/actas_pendientes.png` añadida.
2. **Licencia**: cambiada de MIT a **GPLv3** (`LICENSE` con texto oficial,
   badges y secciones de licencia actualizados en ambos READMEs, cabecera
   de copyright añadida al principio de `index.html`).
3. **Bugfix `sbConfigured()`** (`index.html` ~línea 2785): antes devolvía
   `true` aunque `SUPABASE_URL`/`SUPABASE_ANON_KEY` fueran los placeholders
   literales (son strings no vacíos), lo que hacía que `createClient()` se
   llamara con una URL inválida y la app crasheara con un error enmascarado
   por el navegador como `Script error. Line 0:0` (por no llevar el script
   del CDN el atributo `crossorigin`). Ahora comprueba explícitamente que
   no sean los placeholders.
4. **Banner de bienvenida** cuando el árbol está completamente vacío
   ("Empieza por ti..." + anillo ámbar pulsante sobre el sector central del
   abanico). Confirmado visualmente que funciona.
5. **Fix de tamaño del abanico en pantallas anchas** ✅ **confirmado por el
   usuario**: en desktop, el SVG del abanico se escalaba al 100 % del
   ancho de la ventana y, al mantener su proporción, salía con una altura
   enorme, dejando el sector central muy por debajo del scroll. El fix
   definitivo calcula `width`/`height` explícitos en JS dentro de
   `renderFan()` (usando `holder.clientWidth` y
   `window.innerHeight - holder.getBoundingClientRect().top`) y los
   asigna como atributos del `<svg>` en vez de fiarse del auto-sizing CSS
   (un primer intento con `max-height` en CSS no funcionaba). Nota: en
   las capturas de verificación el Dock de macOS en modo auto-ocultar
   tapaba visualmente parte de la pantalla al pasar el ratón cerca del
   borde — eso es un artefacto del SO al hacer captura, no un bug de la
   app; confirmado que sin el Dock activo se ve bien.
6. Todo lo anterior (puntos 1-5) **ya commiteado y subido a GitHub**.

## Único pendiente real

Retomar el plan de Netlify de la sección "Solución propuesta" de arriba:
conectar el sitio de Netlify a este repo, crear las env vars
`SUPABASE_URL`/`SUPABASE_ANON_KEY` en Netlify, y añadir el `netlify.toml`
con el comando `sed` de sustitución en build. Nada de esto está hecho
todavía — es el siguiente paso al volver.
