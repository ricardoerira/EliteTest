# 🏡 EliteTest

**EliteTest** es una aplicación iOS desarrollada en SwiftUI que permite a los usuarios registrar propiedades (casas, apartamentos, estudios) incluyendo información detallada, ubicación en Google Maps y múltiples fotos desde la galería. El proyecto está construido con el patrón **MVVM**, utiliza **Combine** para el manejo reactivo del estado y emplea **Core Data** para persistencia local.

---

## 📱 Descripción del Proyecto

EliteTest permite:
- Agregar una propiedad con tipo, título, descripción, capacidad, número de camas y baños.
- Seleccionar una ubicación usando Google Maps.
- Subir mínimo 5 imágenes por propiedad.
- Validación dinámica de formularios.
- Guardar propiedades e imágenes asociadas usando **Core Data**.
- Arquitectura limpia basada en **MVVM + Repository Pattern**.

---

## 🚀 Pasos para construir y ejecutar la aplicación

1. **Clona el repositorio**:
   ```bash
   git clone https://github.com/tuusuario/EliteTest.git
   cd EliteTest
2. **Descarga las dependencias con SPM**:

## 📦 Dependencias

| Framework         | Uso principal                                                          |
|-------------------|------------------------------------------------------------------------|
| **SwiftUI**        | Construcción de la interfaz de usuario declarativa                    |
| **Combine**        | Programación reactiva para validación de formularios y manejo de estado |
| **Core Data**      | Persistencia local de entidades como propiedades e imágenes           |
| **Google Maps SDK**| Integración del mapa para seleccionar la ubicación de la propiedad    |


## 🧱 Arquitectura y Principios

El proyecto fue construido siguiendo buenas prácticas de desarrollo y patrones de arquitectura modernos para mejorar la escalabilidad, testabilidad y mantenibilidad.

### 🧩 MVVM (Model-View-ViewModel)
Se utilizó el patrón MVVM para separar de forma clara la interfaz de usuario (View), la lógica de presentación (ViewModel) y los datos (Model), permitiendo una mejor organización y testabilidad.

### 🔁 Repository Pattern
La lógica de persistencia y acceso a datos se abstrae mediante un repositorio (`EstateRepository`) que implementa un protocolo (`EstateRepositoryProtocol`). Esto permite desacoplar el acceso a Core Data del resto de la app, y facilita la implementación de pruebas unitarias.

### 💉 Inyección de Dependencias
La clase `AddEstateViewModel` recibe una instancia del repositorio mediante inyección de dependencias:

