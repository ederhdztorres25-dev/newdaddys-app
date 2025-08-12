# Registration Process

Esta carpeta contiene todas las pantallas relacionadas con el proceso de registro de usuarios en la aplicación.

## Flujo de Registro

El proceso de registro sigue esta secuencia:

1. **Verification Screen** (`verification_screen.dart`)

   - Verificación de email con código de 4 dígitos
   - Primera pantalla del proceso de registro

2. **Profile Preference Screen** (`profile_preference_screen.dart`)

   - Selección del rol: Sugar Baby o Sugar Daddy/Mommy
   - Segunda pantalla del proceso

3. **Personal Details Screen** (`personal_details_screen.dart`)

   - Información personal básica: nombre, género, orientación sexual
   - Tercera pantalla del proceso

4. **Photo Upload Screen** (`photo_upload_screen.dart`)

   - Carga de fotos del perfil (cuadrícula asimétrica)
   - Cuarta pantalla del proceso

5. **Phone Number Screen** (`phone_number_screen.dart`)

   - Ingreso del número de teléfono
   - Quinta pantalla del proceso

6. **Physical Characteristics Screen** (`physical_characteristics_screen.dart`)
   - Características físicas, hábitos y gustos
   - Pantalla final del proceso

## Características Comunes

Todas las pantallas del proceso de registro comparten:

- **CustomAppBar**: AppBar consistente con el estilo de la aplicación
- **Navegación**: Flujo secuencial entre pantallas
- **Validación**: Campos requeridos antes de continuar
- **Diseño**: Consistente con la guía de estilos de la app

## Uso

Para importar todas las pantallas del proceso de registro:

```dart
import 'package:new_daddys_app/screens/registration_process/registration_process.dart';
```

O importar pantallas individuales:

```dart
import 'package:new_daddys_app/screens/registration_process/verification_screen.dart';
```
