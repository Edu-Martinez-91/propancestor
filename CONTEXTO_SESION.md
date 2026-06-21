# Contexto de sesión — propancestor

> Notas de trabajo. No es documentación de usuario (eso es `README.md` /
> `README.en.md`). No contiene credenciales.

## Estado actual: ✅ TODO RESUELTO

GitHub y Netlify ya están unificados y funcionando de extremo a extremo:

- **GitHub**: https://github.com/Edu-Martinez-91/propancestor (rama
  `master`), público, sin credenciales reales en ningún commit.
- **Netlify**: sitio `ubiquitous-cat-fb3b45` (https://ubiquitous-cat-fb3b45.netlify.app),
  enlazado a este repo con despliegue continuo desde `master`.
- **Supabase**: proyecto `pvdibojzizoiqlycfkhe` (el que tiene el esquema de
  `supabase_schema.sql`, tablas `trees`/`persons`). Sus credenciales viven
  como variables de entorno en Netlify (`SUPABASE_URL`,
  `SUPABASE_ANON_KEY`, sin marcar como "secret" — ver por qué abajo),
  nunca en GitHub.
- `netlify.toml` en la raíz del repo ejecuta un `sed` en el build que
  sustituye únicamente la línea de declaración (`var SUPABASE_URL = '...'`)
  por el valor real, dejando intacta la detección de placeholder que usa
  `sbConfigured()` en `index.html`.

Confirmado en producción: las credenciales reales están inyectadas y
`sbConfigured()` evalúa `true` correctamente (sincroniza con Supabase, no
se queda en modo local).

## Cosas a tener en cuenta si se vuelve a tocar esto

1. **Por qué las env vars de Netlify NO van marcadas como "secret"**:
   Netlify tiene un escáner que falla el build si detecta un valor marcado
   como secreto dentro de los archivos publicados. Como el objetivo es
   justo que la URL y la `anon key` acaben en el `index.html` servido al
   navegador (la `anon key` está diseñada para ser pública; la seguridad
   real la dan las políticas RLS), hay que dejarlas sin marcar.
2. **Cuidado con sustituciones `sed` demasiado globales**: la primera
   versión de `netlify.toml` sustituía el texto del placeholder en
   *cualquier* parte del archivo, lo que también rompía la comprobación
   `SUPABASE_URL.indexOf('TU_SUPABASE_URL_AQUI')===-1` dentro de
   `sbConfigured()` (la dejaba siempre en `false`, forzando modo local sin
   avisar). El fix ancla el patrón a la línea completa de declaración
   (`var SUPABASE_URL = 'TU_SUPABASE_URL_AQUI';`), que es única en el
   archivo — ver commit `d8519d1`.
3. **El primer deploy tras enlazar un sitio manual a Git no es
   automático**: hace falta un "Trigger deploy" manual una vez. A partir
   de ahí, cada `git push` a `master` despliega solo.
4. Las variables de entorno de Netlify son **por sitio**, no globales —
   no afectan a otros proyectos/repos que también usen Supabase.

## Historial de cambios de esta sesión (todo en `master`, ya en GitHub)

1. README bilingüe (ES/EN) con sección de valor diferencial y captura del
   panel de actas.
2. Licencia MIT → GPLv3 (texto oficial, badges, cabecera en `index.html`).
3. Bugfix `sbConfigured()` original (placeholders truthy hacían crashear
   `createClient()`).
4. Banner de bienvenida + resalte del sector central cuando el árbol está
   vacío.
5. Fix de tamaño del abanico en pantallas de escritorio anchas.
6. `.gitignore` ampliado para cubrir backups del árbol propio
   (`json_bk/`, `*_bk_*.json`) tras detectar uno sin protección.
7. `netlify.toml` + variables de entorno en Netlify + fix del `sed`
   demasiado global. Verificado en producción.

No queda ningún pendiente conocido de esta ronda de trabajo.
