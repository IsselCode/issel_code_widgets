import 'package:flutter/material.dart';
import 'package:issel_code_widgets/issel_code_widgets.dart';

void main() {
  runApp(const WidgetsExampleApp());
}

class WidgetsExampleApp extends StatelessWidget {
  const WidgetsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'issel_code_widgets',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F6FED),
          surface: Colors.white,
        ),
      ),
      home: const WidgetsGalleryPage(),
    );
  }
}

class WidgetsGalleryPage extends StatefulWidget {
  const WidgetsGalleryPage({super.key});

  @override
  State<WidgetsGalleryPage> createState() => _WidgetsGalleryPageState();
}

class _WidgetsGalleryPageState extends State<WidgetsGalleryPage> {
  final _nameController = TextEditingController(text: 'IsselCode');
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _active = true;
  double _quantity = 2;
  String? _status = 'Activo';
  String? _country = 'mx';
  String _plan = 'Pro';
  int _carouselIndex = 0;
  String _lastAction = 'Listo para probar widgets';

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('issel_code_widgets'),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'App de prueba web',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Catálogo interactivo para validar los widgets principales del paquete.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 880;
                      return Flex(
                        direction: isWide ? Axis.horizontal : Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: isWide ? 6 : 0,
                            child: _Section(
                              title: 'Formulario',
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    IsselTextFormField(
                                      controller: _nameController,
                                      hintText: 'Nombre',
                                      prefixIcon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Campo requerido';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    IsselTextFormField(
                                      controller: _notesController,
                                      hintText: 'Notas internas',
                                      prefixIcon: Icons.edit_note_outlined,
                                      onChanged: (value) {
                                        setState(() {
                                          _lastAction = 'Notas: $value';
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    IsselDropdown<String>(
                                      value: _status,
                                      hintText: 'Estado',
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Activo',
                                          child: Text('Activo'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Pausado',
                                          child: Text('Pausado'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Archivado',
                                          child: Text('Archivado'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() => _status = value);
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    IsselSearchDropdown<String>(
                                      value: _country,
                                      hintText: 'Pais',
                                      maxItemsToShow: 4,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'mx',
                                          child: Text('Mexico'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'co',
                                          child: Text('Colombia'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'pe',
                                          child: Text('Peru'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'cl',
                                          child: Text('Chile'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() => _country = value);
                                      },
                                      onSearchChanged: (value) {
                                        setState(() {
                                          _lastAction = 'Busqueda: $value';
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    IsselToggleField(
                                      title: 'Cuenta activa',
                                      value: _active,
                                      onChanged: (value) {
                                        setState(() => _active = value);
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    IsselStepperField(
                                      title: 'Cantidad',
                                      minValue: 0,
                                      maxValue: 10,
                                      initValue: _quantity,
                                      onChanged: (value) {
                                        setState(() => _quantity = value);
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    IsselButton(
                                      text: 'Validar formulario',
                                      onTap: () {
                                        final valid =
                                            _formKey.currentState?.validate() ??
                                                false;
                                        setState(() {
                                          _lastAction = valid
                                              ? 'Formulario valido'
                                              : 'Formulario incompleto';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: isWide ? 20 : 0,
                            height: isWide ? 0 : 20,
                          ),
                          Expanded(
                            flex: isWide ? 5 : 0,
                            child: _Section(
                              title: 'Estados y seleccion',
                              child: Column(
                                children: [
                                  IsselHeaderActionTile(
                                    title: 'Cliente Demo',
                                    subTitle: 'Plan $_plan',
                                    textButton: 'Accion',
                                    onPressed: () {
                                      setState(() {
                                        _lastAction = 'Header presionado';
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  IsselInfoField(
                                    title: 'Registros',
                                    value: _quantity.toStringAsFixed(0),
                                  ),
                                  const SizedBox(height: 12),
                                  IsselInfoField2(
                                    icon: Icons.link_outlined,
                                    label: 'https://isselcode.dev/demo',
                                    copy: true,
                                    copied: () {
                                      setState(() {
                                        _lastAction = 'URL copiada';
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: IsselRadioTile<String>(
                                          value: 'Basico',
                                          groupValue: _plan,
                                          label: 'Basico',
                                          alignment: Alignment.center,
                                          height: 64,
                                          onChanged: (value) {
                                            setState(() => _plan = value);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: IsselRadioTile<String>(
                                          value: 'Pro',
                                          groupValue: _plan,
                                          label: 'Pro',
                                          alignment: Alignment.center,
                                          height: 64,
                                          onChanged: (value) {
                                            setState(() => _plan = value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      IsselPill(
                                          text:
                                              _active ? 'Activo' : 'Inactivo'),
                                      IsselPill(text: _status ?? 'Sin estado'),
                                      IsselPill(text: 'Plan $_plan'),
                                      IsselPill(
                                        widget:
                                            IsselCircularProgressIndicator(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 130,
                                    child: IsselCarousel(
                                      height: 130,
                                      itemCount: 4,
                                      viewportFraction: 0.32,
                                      selectedScale: 1,
                                      unselectedScale: 0.82,
                                      onChanged: (index) {
                                        setState(() => _carouselIndex = index);
                                      },
                                      itemBuilder:
                                          (context, index, isSelected) {
                                        return DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? colorScheme.primary
                                                : colorScheme.surface,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: colorScheme.outlineVariant,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Item ${index + 1}',
                                              style: TextStyle(
                                                color: isSelected
                                                    ? colorScheme.onPrimary
                                                    : colorScheme.onSurface,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: 'Tabla',
                    child: SizedBox(
                      height: 260,
                      child: IsselTableWidget(
                        header: const IsselHeaderTable(
                          titleHeaders: ['Nombre', 'Estado', 'Plan'],
                        ),
                        rows: [
                          IsselRowTable(
                            cells: [
                              IsselPill(text: _nameController.text),
                              IsselPill(text: _status ?? 'Sin estado'),
                              IsselPill(text: _plan),
                            ],
                          ),
                          IsselRowTable(
                            cells: [
                              IsselPill(text: 'Demo ${_carouselIndex + 1}'),
                              IsselPill(text: _active ? 'Activo' : 'Inactivo'),
                              IsselPill(text: 'Cantidad $_quantity'),
                            ],
                          ),
                        ],
                        onTapRow: (index) {
                          setState(() {
                            _lastAction = 'Fila $index presionada';
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  IsselInfoField2(
                    icon: Icons.bolt_outlined,
                    label: _lastAction,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      IsselShimmer(width: 140, height: 40),
                      SizedBox(width: 12),
                      IsselShimmer(width: 220, height: 40),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
