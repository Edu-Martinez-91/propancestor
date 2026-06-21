<div align="center">

<img src="docs/logo.svg" alt="Propancestor" width="120" height="120">

# Propancestor

**Herramienta de investigación genealógica para árboles personales — un solo archivo HTML, sin frameworks, sin build, sin npm.**

[![Made with vanilla JS](https://img.shields.io/badge/Vanilla-JS-f7df1e?logo=javascript&logoColor=black)](https://developer.mozilla.org/docs/Web/JavaScript)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ecf8e?logo=supabase&logoColor=white)](https://supabase.com)
[![Deploy: Netlify](https://img.shields.io/badge/Deploy-Netlify-00c7b7?logo=netlify&logoColor=white)](https://ubiquitous-cat-fb3b45.netlify.app)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](#licencia)
[![Single file](https://img.shields.io/badge/Single--file-HTML-orange)]()

### [Usar la app ahora](https://ubiquitous-cat-fb3b45.netlify.app)

*Abre `index.html` en cualquier navegador, o usa directamente el enlace de arriba — no requiere instalación. Puedes crear una cuenta ahí mismo si quieres que tu árbol se sincronice entre dispositivos (opcional).*

🇪🇸 **Español** · [🇬🇧 English](README.en.md)

</div>

---

## ¿Qué es esto?

**Propancestor** es una aplicación web para investigar y visualizar tu árbol genealógico. Está pensada para personas que buscan partidas en registros civiles y archivos parroquiales españoles: cada acta encontrada se vuelca al árbol, los rangos de fechas se triangulan con los datos de hijos y hermanos, y el siguiente acta a buscar aparece sola, ordenada por probabilidad y vía documental.

Toda la aplicación cabe en un único `index.html`. Funciona sin conexión gracias a `localStorage` y sincroniza en la nube con Supabase cuando hay red. Cero dependencias en el navegador, cero pasos de build.

---

## ¿Por qué Propancestor?

La mayoría de árboles genealógicos online (FamilySearch, MyHeritage, Geni...) están diseñados para diásporas: familias que migraron entre países a lo largo de los siglos, y cuyo árbol se mueve por continentes en pocas generaciones. **Propancestor nace de un caso distinto: el de familias españolas sin apenas movilidad geográfica**, donde lo que importa no es por qué país pasó cada antepasado, sino por qué *pueblo*.

1. **Granularidad de pueblo, no de país.** Donde FamilySearch te ofrece un campo "país" por persona, aquí cada perfil tiene su municipio de nacimiento, y el abanico se puede colorear por pueblo para ver de un vistazo cómo se concentran o dispersan las raíces familiares en una misma comarca.

2. **Aprovecha la trazabilidad del sistema español de apellidos.** En España las mujeres no pierden su apellido al casarse, y cada persona lleva dos apellidos (uno paterno, uno materno) en vez de uno solo. Eso da una trazabilidad documental que no existe en otros países, y es justo lo que permite la propagación de datos del punto siguiente: un apellido materno en un acta identifica directamente a una estirpe completa, no se diluye en una generación.

3. **Propagación de la información hacia generaciones anteriores.** Al introducir los datos de un acta de nacimiento (civil o parroquial) de un antepasado, la app no solo registra a esa persona: prepara automáticamente el perfil de sus padres con los datos que ya constan en el acta (nombre, edad declarada, origen), listos para pedir *sus* actas. Y si esa misma acta declara también la edad y el pueblo de origen de los abuelos —algo habitual en partidas antiguas—, **Propancestor** da un paso más y prepara también los perfiles de los abuelos. Una sola visita al registro o al archivo puede destapar tres generaciones de golpe.

4. **Calculador de rangos de edad de nacimiento.** Cada acta aporta una edad declarada de los padres en ese momento; la app cruza esa información con la de hermanos y descendientes para ir estrechando, por intersección de ventanas, el rango de nacimiento real de cada antepasado — incluso de aquellos de los que nunca se llegue a tener un acta propia.

5. **Guía documental específica del caso español.** La app distingue automáticamente si un acta hay que pedirla en el **Registro Civil** (nacimientos desde el 1 de enero de 1871) o en el **archivo parroquial** (anteriores a esa fecha), y permite marcar cuándo una solicitud ha sido rechazada en uno u otro lugar para reordenar las prioridades. La lista de "actas a buscar" se puede ordenar por fecha de nacimiento más reciente (las más fáciles de obtener primero) y filtrar por pueblo, para que al planificar una visita a una sola parroquia tengas ya lista la lista completa de partidas que puedes pedir allí.

---

## El abanico

El núcleo visual es un abanico radial editable, con texto longitudinal (los nombres se leen siguiendo el radio) y tres modos de coloreado:

### Por estirpe
Cada cuadrante hereda un tono distinto, con la saturación aumentando con la cantidad de información conocida.

<p align="center"><img src="docs/fan_branch.png" alt="Abanico por estirpe" width="780"></p>

### Por estado del acta
Verde si la partida está obtenida, ámbar si está lista para buscar, granate si los rangos de fuentes son inconexos.

<p align="center"><img src="docs/fan_status.png" alt="Abanico por estado del acta" width="780"></p>

### Por pueblo de nacimiento
Un color HSL único para cada municipio del árbol, con leyenda automática.

<p align="center"><img src="docs/fan_town.png" alt="Abanico por pueblo" width="780"></p>

### Panel "Actas a buscar"
Lista priorizada de partidas pendientes, clasificadas en Registro Civil / Parroquia / vías agotadas, filtrables por pueblo y ordenables por fecha de nacimiento. El tick "Acta solicitada" arranca una cuenta de días en espera por persona.

<p align="center"><img src="docs/actas_pendientes.png" alt="Panel de actas a buscar con contador de días en espera" width="780"></p>

---

## Características

- **Triangulación de rangos.** Si conoces que tu bisabuelo tenía 27 años cuando nació tu abuela (acta de la abuela) y 33 cuando nació tu tío-abuelo (acta del tío), el rango de nacimiento del bisabuelo se calcula con la intersección de las dos ventanas.
- **Propagación bidireccional.** El lugar de nacimiento puesto en el perfil del padre se replica al campo "origen del padre" del acta del hijo, y viceversa. Si las dos puntas tienen fecha exacta, las edades declaradas se recalculan a la edad real.
- **Panel "actas a buscar".** Lista de las próximas partidas con un sólo botón a la sede electrónica del Ministerio de Justicia y guía paso a paso para rellenar el formulario.
- **Tick de acta solicitada.** Contador de días en espera por persona, reiniciable cuando se pide a otro registro. Se cierra solo al introducir la fecha exacta.
- **Apellidos predominantes.** Conteo agrupado por línea genealógica (paterna/materna), con normalización de variantes (`Díaz-Maroto`/`Diaz Maroto`/`de Diaz Maroto` cuentan como el mismo).
- **Detección de incongruencias.** Avisos cuando las edades declaradas en el acta del hijo y las del acta de un hermano dan rangos sin solape, o cuando los apellidos del nieto no se corresponden con los del abuelo.
- **Defunciones.** Campos de fecha y lugar de defunción por persona, con propagación de pista "ya estaba difunto en el acta del hijo".
- **Modal de configuración.** Cuenta, importar JSON/GEDCOM, exportar JSON/GEDCOM. Logo SVG animado a la izquierda, engranaje a la derecha.
- **Comparación antes de importar o sincronizar.** Si el JSON/GEDCOM que importas, o el árbol que hay en tu cuenta al iniciar sesión, no coincide con lo que ya tienes en este dispositivo, aparece un aviso con el recuento de personas y hermanos de cada lado y tres opciones explícitas — combinar (campo a campo, sin perder nada ya verificado), mantener el árbol actual, o sustituir por el entrante — para que ningún import o login pueda borrar datos genealógicos sin que lo decidas tú mismo.
- **Offline-first.** Toda la app vive en `localStorage`. Cuando hay red, una outbox sincroniza los cambios con Supabase.
- **Cero emojis en producción.** Una librería interna de iconos SVG (`ICONS`) sustituye a los emojis: rendering consistente entre iOS, Android y escritorio.
- **iOS-safe.** Sin optional chaining, sin nullish coalescing, sin `continue` dentro de `forEach`. Probado en Safari iOS antiguos.

---

## Stack

| Capa | Tecnología |
|------|------------|
| **Frontend** | Un solo archivo HTML con `<style>` y `<script>` inline. Vanilla JS ES5 estricto. Sin frameworks. |
| **Backend** | [Supabase](https://supabase.com) — Postgres + Auth + Row Level Security. Una tabla `trees` y una tabla `persons` con columna `data JSONB` que acepta cualquier estructura sin migración. |
| **Persistencia local** | `localStorage` con outbox para cambios pendientes cuando no hay red. |
| **Hosting** | [Netlify](https://www.netlify.com), `index.html` raíz. Despliegue continuo desde `main`. |
| **Iconos** | SVG inline minimalista, estilo Feather/Lucide, `stroke=currentColor` para herencia de color. |
| **Tipografía** | EB Garamond (cabeceras) + Inter (UI). Servidas vía `<link>`, no `@import` (compatibilidad WKWebView). |

---

## Cómo lo uso para mi propio árbol

1. **Descarga o clona el repo** y abre `index.html` en el navegador (funciona también haciendo doble clic, sin servidor).
2. Tu perfil (el "probando") aparece en el centro del abanico. Pulsa un sector vacío para abrir su ficha y rellenar lo que sepas.
3. Cada vez que pongas una edad declarada, un lugar de nacimiento o un nombre de abuelo en el acta de un descendiente, esos datos se propagan automáticamente al perfil correspondiente.
4. Cuando un perfil tenga fecha estimada y lugar, aparecerá en la pestaña **Actas a buscar** con su clasificación (Registro Civil ≥1871 o Parroquia <1871).
5. En las del Registro Civil, el botón **Solicitar certificado** abre la sede del Ministerio de Justicia y muestra la guía paso a paso.
6. Marca el tick de "Acta solicitada" para empezar a contar los días de espera. Cuando recibas el certificado y pongas la fecha exacta, el acta desaparecerá de la lista de pendientes.
7. (Opcional) Configura tu propio Supabase — ver sección siguiente — para sincronizar entre dispositivos. Sin esto, la app funciona igual en modo local.

---

## Despliega tu propio backend

El `index.html` de este repositorio **no incluye credenciales reales** — verás `TU_SUPABASE_URL_AQUI` en su lugar. Sin ellas la app funciona igualmente: cae automáticamente en **modo local** (todo en `localStorage`, sin sincronización en la nube). Para tener sincronización entre dispositivos:

1. Crea un proyecto gratuito en [supabase.com](https://supabase.com).
2. Ejecuta el SQL de [`supabase_schema.sql`](supabase_schema.sql) en el SQL Editor. Esto crea las tablas `trees` y `persons`, y las políticas RLS para que cada usuario solo vea sus propios datos.
3. En `index.html`, sustituye `SUPABASE_URL` y `SUPABASE_ANON_KEY` por los de tu proyecto (los encuentras en *Project Settings → API*).
4. Sube el `index.html` a Netlify (o GitHub Pages, Vercel, Cloudflare Pages, un cubo S3, lo que sea — es un archivo estático).

> ⚠️ La `anon key` de Supabase es pública por diseño. La seguridad real la dan las políticas RLS, no esconder la clave. Aun así, este repo no expone ningún proyecto real para evitar tráfico cruzado sobre cuentas ajenas.

---

## Estructura del repositorio

```
.
├── index.html                  # La aplicación entera (~3.300 líneas)
├── arbol_datos_ejemplo.json    # Dataset ficticio para probar el import
├── supabase_schema.sql         # Tablas y RLS para replicar el backend
├── docs/
│   ├── logo.svg                # Logo del proyecto
│   ├── fan_branch.png          # Captura abanico por estirpe
│   ├── fan_status.png          # Captura abanico por estado
│   ├── fan_town.png            # Captura abanico por pueblo
│   └── actas_pendientes.png    # Captura panel de actas con contador de espera
├── README.md                   # Este archivo (español)
└── README.en.md                # Versión en inglés
```

---

## Filosofía

- **Un solo archivo.** Sin build, sin transpilación, sin árboles de dependencias. Abrir el HTML en cualquier navegador y la app funciona.
- **Sin frameworks.** La complejidad ya está en el dominio (genealogía, propagación de datos, triangulación de rangos). No hace falta añadirle React encima.
- **Local-first.** Los datos viven en tu dispositivo. La nube es un espejo opcional, no la fuente de verdad.
- **Datos sobre estilo.** El abanico es el corazón de la app, pero la prioridad es que los datos estén consistentes y que la triangulación funcione. La interfaz es el medio para verlos.

---

## Roadmap

- [ ] Importación inteligente de actas escaneadas (OCR)
- [ ] Vista de mapa con los pueblos del árbol y desplazamientos generacionales
- [ ] Estadística de longevidad por línea
- [ ] Exportación a PDF del abanico
- [ ] Búsqueda federada en archivos diocesanos abiertos

---

## Licencia

[GPLv3](LICENSE). Puedes usarlo, estudiarlo, modificarlo y redistribuirlo libremente, siempre que cualquier versión modificada que distribuyas siga siendo de código abierto bajo la misma licencia — no se permiten forks cerrados o propietarios.

---

<div align="center">
<sub>Hecho con cariño en Madrid · 2026</sub>
</div>
