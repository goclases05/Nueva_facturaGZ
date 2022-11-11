/*  Future<List<int>> testTicket(String id_factura) async {
   



    //espacio
    bytess += generatorr.feed(1);

    //FEL
    if (encabezado[0].dte != '') {
      bytess += generatorr.text('Factura Electrónica Documento Tributario',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //FECHA EMITIDA
    bytess += generatorr.text(encabezado[0].fecha_letras,
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //AUTORIZACION
    if (encabezado[0].dte != '') {
      bytess += generatorr.text('Número de Autorización:',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));

      bytess += generatorr.text(encabezado[0].dte,
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));

      bytess += generatorr.text('Serie: ${encabezado[0].serieDte}',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));

      bytess += generatorr.text('Número de DTE: ${encabezado[0].noDte}',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //No
    bytess += generatorr.text('No: ${encabezado[0].no}',
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //SERIE
    bytess += generatorr.text('Serie: ${encabezado[0].serie}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //VENDEDOR
    bytess += generatorr.text(
        'Vendedor : ${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //CLIENTE
    bytess += generatorr.text(
        'Cliente: ${encabezado[0].nombre} ${encabezado[0].apellidos}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //NIT CLIENTE
    bytess += generatorr.text('NIT: ${encabezado[0].nit}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //DIRECCION CLIENTE
    if (encabezado[0].direccionCli != '') {
      bytess += generatorr.text('Dirección: ${encabezado[0].direccionCli}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //CONDICIONES DE PAGO
    bytess += generatorr.text('Condiciones de pago:',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('${encabezado[0].forma}',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //TABLA PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Descripción',
        width: 9,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: 'Subtotal',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //Detalle productos
    for (int al = 0; al < detalle.length; al++) {
      double tota =
          double.parse(detalle[al].cantidad) * double.parse(detalle[al].precio);
      bytess += generatorr.row([
        PosColumn(
          text: '${detalle[al].producto}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytess += generatorr.row([
        PosColumn(
          text:
              '${detalle[al].cantidad} * ${detalle[al].contenido}${detalle[al].precio}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${detalle[al].contenido}${tota}',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    //DESCUENTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Descuento(-):',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].descuento,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //TOTAL PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Total:',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].total,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //espacio
    bytess += generatorr.feed(1);

    //TOTAL LETRAS
    bytess += generatorr.text('${encabezado[0].totalLetas}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //Frases
    for (int rl = 0; rl < encabezado[0].frases.length; rl++) {
      bytess += generatorr.text(encabezado[0].frases[rl],
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //DATOS DE CERTIFICADOR
    if (encabezado[0].dte != '') {
      bytess += generatorr.text('Certificador: ${encabezado[0].certificador}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));

      bytess += generatorr.text('NIT: ${encabezado[0].nitCert}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));

      bytess += generatorr.text('Fecha: ${encabezado[0].fechaCert}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //datos del sistema
    bytess += generatorr.text('Realizado en www.gozeri.com',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    bytess += generatorr.cut();
    return bytess;
  }
}*/