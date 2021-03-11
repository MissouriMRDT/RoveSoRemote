library rovecomm;

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:developer' as developer;

RawDatagramSocket socket;
int RoveCommUDPPort = 11000;

enum DataTypes {
  INT8_T,
  UINT8_T,
  INT16_T,
  UINT16_T,
  INT32_T,
  UINT32_T,
  FLOAT_T,
  DOUBLE_T,
  CHAR,
}

var DataSize = {
  0: 1,
  1: 1,
  2: 2,
  3: 2,
  4: 4,
  5: 4,
  6: 4,
  7: 8,
  8: 8,
  9: 1,
};

var callbacks = {};

StreamController stream;

List decodePacket(int datatype, int datacount, ByteData buf) {
  final dataType = DataTypes.values[datatype];

  var retArray = [];
  var offset = 0;
  print(buf.lengthInBytes);
  switch (dataType) {
    case DataTypes.INT8_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(buf.getInt8(offset));
      }
      return retArray;
    case DataTypes.UINT8_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(buf.getUint8(offset));
      }
      return retArray;
    case DataTypes.INT16_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(buf.getInt16(offset));
      }
      print(retArray);
      return retArray;
    case DataTypes.UINT16_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(buf.getUint16(offset));
      }
      return retArray;
    case DataTypes.INT32_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(buf.getInt32(offset));
      }
      return retArray;
    case DataTypes.UINT32_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(buf.getUint32(offset));
      }
      return retArray;
    case DataTypes.FLOAT_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(double.parse(buf.getFloat32(offset).toStringAsFixed(6)));
      }
      return retArray;
    case DataTypes.DOUBLE_T:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(double.parse(buf.getFloat64(offset).toStringAsFixed(10)));
      }
      return retArray;
    case DataTypes.CHAR:
      for (int i = 0; i < datacount; i++) {
        offset = i * DataSize[datatype];
        retArray.add(buf.getUint8(offset).toString());
      }
      return retArray;
    default:
      print("Unknown type");
      return [];
  }
}

/// Parses data found in the given [data] packet. Takes care of decoding and then emitting
/// events.
void parsePackets(data) {
  //Read in the data as a Int32List, then grab the buffer as bytes
  //print(data);
  var bytes = Uint8List.fromList(data);

  const VersionNumber = 2;
  const headerLength = 5;

  // Reading in the header
  final version = bytes[0];
  final dataId = bytes[1] << 8 | bytes[2];
  final dataCount = bytes[3];
  final dataType = bytes[4];

  var rawdata = bytes.sublist(headerLength);

  if (version == VersionNumber) {
    data = decodePacket(dataType, dataCount, new ByteData.view(rawdata.buffer));
    // Call any functions that have asked to be notified of this packet
    if (callbacks.containsKey(dataId)) {
      for (Function func in callbacks[dataId]) {
        func(data);
      }
    }
  }
}

class RoveComm {
  RawDatagramSocket udpSock;
  var tcpSock;

  RoveComm() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 11000)
        .then((RawDatagramSocket sock) {
      udpSock = sock;
      sock.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    });
  }

  void dataHandler(data) {
    var packet = udpSock.receive();
    if (packet != null) {
      parsePackets(packet.data);
    }
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.close();
  }

  void sendCommand(
      String dataId, DataTypes datatype, data, String ip, bool reliable) {
    const VersionNumber = 2;

    //single items are also treated as lists
    if (!(data is List)) {
      data = [data];
    }
    final dataCount = data.length;
    final port = 11000;
    final headerLength = 5;

    // Allocating the right number of bytes (size of full packet)
    var buff = ByteData(headerLength + dataCount * DataSize[datatype.index]);

    // Setting the header bytes
    buff.setUint8(0, VersionNumber);
    buff.setUint16(1, int.parse(dataId));
    buff.setUint8(3, dataCount);
    buff.setUint8(4, datatype.index);

    switch (datatype) {
      case DataTypes.INT8_T:
        for (int i = 0; i < data.length; i++) {
          buff.setInt8(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.UINT8_T:
        for (int i = 0; i < data.length; i++) {
          buff.setUint8(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.INT16_T:
        for (int i = 0; i < data.length; i++) {
          buff.setInt16(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.UINT16_T:
        for (int i = 0; i < data.length; i++) {
          buff.setUint16(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.INT32_T:
        for (int i = 0; i < data.length; i++) {
          buff.setInt32(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.UINT32_T:
        for (int i = 0; i < data.length; i++) {
          buff.setUint32(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.FLOAT_T:
        for (int i = 0; i < data.length; i++) {
          buff.setFloat32(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.DOUBLE_T:
        for (int i = 0; i < data.length; i++) {
          buff.setFloat64(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
      case DataTypes.CHAR:
        for (int i = 0; i < data.length; i++) {
          buff.setInt8(5 + i * DataSize[datatype.index], data[i]);
        }
        break;
    }
    Uint8List listBuffer = buff.buffer.asUint8List();
    var bytes = udpSock.send(listBuffer, InternetAddress(ip), port);
  }
}

// Initialize RoveComm node
final RC_Node = RoveComm();
