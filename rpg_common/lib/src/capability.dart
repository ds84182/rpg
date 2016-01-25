part of rpg_common;

abstract class Capable {
  Map<Type, Capability> capabilities = {};

  bool hasCapability(Type cap) =>
      capabilities.containsKey(cap);

  Capability getCapability(Type cap) =>
      capabilities[cap];

  Capability addCapability(Capability cap) =>
      capabilities[cap.runtimeType] = cap;

  Capability removeCapability(Type cap) =>
      capabilities.remove(cap);
}

class Capability {
  const Capability();
}
