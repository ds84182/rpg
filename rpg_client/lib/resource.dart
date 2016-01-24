part of rpg_client;

typedef Future<dynamic> ResourceLoader(String name);

class Resource {
  static Map<String, dynamic> loadedResources = {};
  static List<String> loadingResources = [];
  static StreamController resourceLoadEventStreamController = new StreamController.broadcast();
  static Stream resourceLoadEventStream = resourceLoadEventStreamController.stream;

  static Map<String, ResourceLoader> resourceLoaders = {
    ".png": (name) {
      var image = new ImageElement(src: name);

      if (image.complete)
        return new Future.value(image);

      Completer<ImageElement> completer = new Completer();

      image.onLoad.first.then((ev) {
        completer.complete(image);
      });

      image.onError.first.then((ev) {
        completer.completeError("Image loading failed!");
      });

      return completer.future;
    }
  };

  static dynamic get(String name) {
    if (loadedResources.containsKey(name)) {
      return loadedResources[name];
    }

    if (!loadingResources.contains(name)) {
      _doload(name);
    }

    return null;
  }

  static Future<dynamic> _doload(String name) {
    Future<dynamic> result;

    for (var key in resourceLoaders.keys) {
      if (name.endsWith(key)) {
        loadingResources.add(name);
        result = resourceLoaders[key](name);
        break;
      }
    }

    if (result == null) {
      throw "No loader to load resource $name";
    }

    return result.then((res) {
      print("Loaded resource $name");
      loadedResources[name] = res;
      loadingResources.remove(name);
      resourceLoadEventStreamController.add(name);
      return res;
    });
  }

  static Future<dynamic> load(String name) {
    if (loadedResources.containsKey(name)) {
      return new Future.value(loadedResources[name]);
    }

    if (loadingResources.contains(name)) {
      return resourceLoadEventStream.firstWhere((n) => n == name).then((n) {
        return loadedResources[name];
      });
    }

    return _doload(name);
  }
}
