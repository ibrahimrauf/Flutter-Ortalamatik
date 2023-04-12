import 'package:flutter/material.dart';

void main() {
  runApp(NotHesaplama());
}

class NotHesaplama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinamik Not Hesaplama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const DinamikNotHesaplama(),
    );
  }
}

class DinamikNotHesaplama extends StatefulWidget {
  const DinamikNotHesaplama({super.key});

  @override
  _DinamikNotHesaplamaState createState() => _DinamikNotHesaplamaState();
}

class _DinamikNotHesaplamaState extends State<DinamikNotHesaplama> {
  double krediToplam = 0, ortalamaToplam = 0;
  List<Ders> dersListesi = <Ders>[];
  int sayac = 0;
  late String dersAdi;
  late double kredi, harfNotu;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Ortalamatik"),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              backgroundColor: Colors.orange,
              child: const Icon(
                Icons.refresh,
              ),
              mini: true,
              onPressed: () {
                setState(() {
                  kredi = 1;
                  harfNotu = 4;
                  krediToplam = 0;
                  ortalamaToplam = 0;
                  dersListesi.clear();
                });
              }),
          FloatingActionButton(
            onPressed: () {
              setState(
                () {
                  if (_formKey.currentState!.validate()) {
                    krediToplam += kredi;
                    ortalamaToplam += (kredi * harfNotu);
                    dersListesi.add(Ders(dersAdi, kredi, harfNotu));
                  } else {
                    const Text("Formu boş bırakmayınız.");
                  }
                },
              );
            },
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return uygulama();
        } else {
          return uygulamaYatay();
        }
      }),
    );
  }

  Widget uygulama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    hintText: "Ders adını giriniz",
                    labelText: "Ders Adı",
                  ),
                  validator: (e) {
                    if (e!.length < 2) {
                      return "Ders adı en az iki karakter olmalı.";
                    }
                    return null;
                  },
                  onChanged: (e) {
                    dersAdi = e;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButton<double>(
                          items: dersKredileri(),
                          value: kredi,
                          onChanged: (e) {
                            setState(() {
                              kredi = e!;
                            });
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButton<double>(
                          items: harfNotlari(),
                          value: harfNotu,
                          onChanged: (e) {
                            setState(() {
                              harfNotu = e!;
                            });
                          }),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.yellow,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Ortalama: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                      TextSpan(
                        text: (ortalamaToplam /
                                (krediToplam == 0 ? 1 : krediToplam))
                            .toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: dersListesi.length,
                itemBuilder: (context, i) {
                  sayac++;
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    key: Key("$sayac"),
                    onDismissed: (direction) {
                      setState(() {
                        debugPrint(i.toString());
                        krediToplam -= dersListesi[i]._kredi;
                        ortalamaToplam -=
                            (dersListesi[i]._kredi * dersListesi[i]._harfNotu);
                        dersListesi.removeAt(i);
                      });
                    },
                    child: Card(
                      color: Colors.yellow.shade200,
                      child: ListTile(
                        leading: Icon(
                          Icons.check,
                          size: 30,
                        ),
                        title: Text(dersListesi[i]._dersAdi),
                        subtitle: Text(
                            "Kredi: ${dersListesi[i]._kredi.toInt()}   Not: ${dersListesi[i]._harfNotu}"),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget uygulamaYatay() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                      // ignore: prefer_const_constructors
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      // ignore: prefer_const_constructors
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                      hintText: "Ders adını giriniz",
                      labelText: "Ders Adı",
                    ),
                    validator: (e) {
                      if (e!.length < 2) {
                        return "Ders adı en az iki karakter olmalı.";
                      }
                      return null;
                    },
                    onChanged: (e) {
                      dersAdi = e;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                              items: dersKredileri(),
                              value: kredi,
                              onChanged: (e) {
                                setState(() {
                                  kredi = e!;
                                });
                              }),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                              items: harfNotlari(),
                              value: harfNotu,
                              onChanged: (e) {
                                setState(() {
                                  harfNotu = e!;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(
                      children: [
                        // ignore: prefer_const_constructors
                        TextSpan(
                          text: "Ortalama: ",
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        TextSpan(
                          text: (ortalamaToplam /
                                  (krediToplam == 0 ? 1 : krediToplam))
                              .toStringAsFixed(2),
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: dersListesi.length,
                itemBuilder: (context, i) {
                  sayac++;
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    key: Key("$sayac"),
                    onDismissed: (direction) {
                      setState(() {
                        debugPrint(i.toString());
                        krediToplam -= dersListesi[i]._kredi;
                        ortalamaToplam -=
                            (dersListesi[i]._kredi * dersListesi[i]._harfNotu);
                        dersListesi.removeAt(i);
                      });
                    },
                    child: Card(
                      color: Colors.grey.shade200,
                      child: ListTile(
                        leading: const Icon(
                          Icons.check,
                          size: 30,
                        ),
                        title: Text(dersListesi[i]._dersAdi),
                        subtitle: Text(
                            "Kredi: ${dersListesi[i]._kredi.toInt()}   Harf Notu: ${dersListesi[i]._harfNotu}"),
                        trailing: const Icon(
                          Icons.arrow_right,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<double>> dersKredileri() {
    return List.generate(10, (i) {
      return DropdownMenuItem<double>(
        value: (i + 1).toDouble(),
        child: Text("${i + 1} Kredi"),
      );
    });
  }

  List<DropdownMenuItem<double>> harfNotlari() {
    return [
      const DropdownMenuItem<double>(value: 4, child: Text("90-100")),
      const DropdownMenuItem<double>(value: 3.5, child: Text("89-85")),
      const DropdownMenuItem<double>(value: 3, child: Text("84-80")),
      const DropdownMenuItem<double>(value: 2.5, child: Text("79-75")),
      const DropdownMenuItem<double>(value: 2, child: Text("74-70")),
      const DropdownMenuItem<double>(value: 1.5, child: Text("69-64")),
      const DropdownMenuItem<double>(value: 1, child: Text("64-60")),
      const DropdownMenuItem<double>(value: 0.5, child: Text("59-50")),
      const DropdownMenuItem<double>(value: 0, child: Text("49-0")),
    ];
  }
}

class Ders {
  final String _dersAdi;
  // ignore: prefer_final_fields
  double _kredi, _harfNotu;

  Ders(this._dersAdi, this._kredi, this._harfNotu);
}
