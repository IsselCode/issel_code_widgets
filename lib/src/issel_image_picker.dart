import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Selector de imágenes compatible con [Form].
///
/// Abre [FilePicker] por defecto, guarda los bytes seleccionados en el valor
/// del campo y permite validar la selección. También puede recibir una
/// función personalizada mediante [pickImage].
class IsselImagePicker extends FormField<Uint8List?> {
  /// Bytes de la imagen inicial o actualmente seleccionada.
  final Uint8List? bytes;

  /// Indica si la aplicación está ocupada con una operación externa.
  final bool loading;

  /// Callback invocado cuando el usuario toca el selector.
  final VoidCallback? onTap;

  /// Callback invocado después de seleccionar una imagen correctamente.
  final ValueChanged<Uint8List?>? onChanged;

  /// Selector opcional para reemplazar el uso predeterminado de [FilePicker].
  final Future<Uint8List?> Function()? pickImage;

  /// Callback invocado si falla la selección de la imagen.
  final ValueChanged<Object>? onError;

  /// Altura del selector.
  final double height;

  /// Ancho del selector.
  final double width;

  /// Radio de las esquinas.
  final double borderRadius;

  /// Color de fondo del selector. Por defecto usa [ColorScheme.surface].
  final Color? backgroundColor;

  /// Texto mostrado cuando no hay una imagen seleccionada.
  final String placeholderText;

  /// Icono mostrado cuando no hay una imagen seleccionada.
  final IconData placeholderIcon;

  /// Contenido personalizado para el estado vacío.
  final Widget? placeholder;

  /// Indicador personalizado para el estado de carga.
  final Widget? loadingWidget;

  /// Indica si se muestra el botón para limpiar la imagen seleccionada.
  final bool showClearButton;

  /// Icono mostrado en el botón para limpiar la imagen.
  final IconData clearIcon;

  /// Color de fondo del botón para limpiar la imagen.
  final Color? clearIconBackgroundColor;

  /// Color del icono para limpiar la imagen.
  final Color? clearIconColor;

  /// Ajuste usado para mostrar la imagen seleccionada.
  final BoxFit fit;

  /// Crea un selector de imágenes para usar dentro de un [Form].
  IsselImagePicker({
    super.key,
    this.bytes,
    this.loading = false,
    this.onTap,
    this.onChanged,
    this.pickImage,
    this.onError,
    this.height = 210,
    this.width = double.infinity,
    this.borderRadius = 18,
    this.backgroundColor,
    this.placeholderText = 'Seleccionar imagen',
    this.placeholderIcon = Icons.add_a_photo_outlined,
    this.placeholder,
    this.loadingWidget,
    this.showClearButton = true,
    this.clearIcon = Icons.close_outlined,
    this.clearIconBackgroundColor,
    this.clearIconColor,
    this.fit = BoxFit.cover,
    FormFieldValidator<Uint8List?>? validator,
    AutovalidateMode? autovalidateMode,
  }) : super(
          initialValue: bytes,
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (state) {
            final pickerState = state as _IsselImagePickerState;
            final theme = Theme.of(state.context);
            final colors = theme.colorScheme;
            final isLoading =
                pickerState._picking || pickerState.widget.loading;
            final imageBytes = pickerState.value;
            final background =
                pickerState.widget.backgroundColor ?? colors.surface;

            Widget content;
            if (isLoading) {
              content = Center(
                child: pickerState.widget.loadingWidget ??
                    const CircularProgressIndicator(),
              );
            } else if (imageBytes == null) {
              content = pickerState.widget.placeholder ??
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        pickerState.widget.placeholderIcon,
                        color: colors.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(pickerState.widget.placeholderText),
                    ],
                  );
            } else {
              content = Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(imageBytes, fit: pickerState.widget.fit),
                  if (pickerState.widget.showClearButton)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Material(
                        color: pickerState.widget.clearIconBackgroundColor ??
                            colors.primary,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: pickerState._clearImage,
                          customBorder: const CircleBorder(),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              pickerState.widget.clearIcon,
                              color: pickerState.widget.clearIconColor ??
                                  colors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  button: !isLoading,
                  label: pickerState.widget.placeholderText,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isLoading ? null : pickerState._pickImage,
                      borderRadius: BorderRadius.circular(
                        pickerState.widget.borderRadius,
                      ),
                      child: Container(
                        height: pickerState.widget.height,
                        width: pickerState.widget.width,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(
                            pickerState.widget.borderRadius,
                          ),
                        ),
                        child: content,
                      ),
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: colors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

  @override
  FormFieldState<Uint8List?> createState() => _IsselImagePickerState();
}

class _IsselImagePickerState extends FormFieldState<Uint8List?> {
  bool _picking = false;

  @override
  IsselImagePicker get widget => super.widget as IsselImagePicker;

  @override
  void didUpdateWidget(IsselImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.bytes, widget.bytes)) {
      setValue(widget.bytes);
    }
  }

  Future<void> _pickImage() async {
    if (_picking || widget.loading) return;

    widget.onTap?.call();
    setState(() => _picking = true);
    try {
      final selectedBytes = widget.pickImage != null
          ? await widget.pickImage!()
          : await _pickImageWithFilePicker();
      if (!mounted || selectedBytes == null) return;
      didChange(selectedBytes);
      widget.onChanged?.call(selectedBytes);
    } catch (error) {
      if (mounted) widget.onError?.call(error);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _clearImage() {
    if (_picking || widget.loading) return;
    didChange(null);
    widget.onChanged?.call(null);
  }

  Future<Uint8List?> _pickImageWithFilePicker() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    return file?.readAsBytes();
  }
}
