import 'package:bonfire/bonfire.dart';

export 'package:bonfire/forces/forces_2d.dart';

/// 컴포넌트가 전역(global) 또는 로컬(local) 힘의 영향을 받도록 하는 믹스인(mixin)입니다.
/// 로컬 힘을 추가하려면 `addForce` 메서드를 호출하세요. 전역 힘을 추가하려면
/// `BonfireWidget`의 `globalForces` 매개변수를 사용하세요.
mixin HandleForces on Movement {
  /// 컴포넌트의 질량(mass).
  double _mass = 1.0;

  bool handleForcesEnabled = true;
  bool handleForcesOnlyVisible = true;

  set mass(double mass) {
    assert(mass >= 1);
    _mass = mass;
  }

  double get mass => _mass;

  final List<Force2D> _forces = [];

  void addForce(Force2D force) {
    _forces.removeWhere((element) => element.id == force.id);
    _forces.add(force);
  }

  void removeForce(dynamic id) {
    _forces.removeWhere((element) => element.id == id);
  }

  @override
  Vector2 onVelocityUpdate(double dt, Vector2 velocity) {
    if (handleForcesOnlyVisible) {
      if (!isVisible) {
        return super.onVelocityUpdate(dt, velocity);
      }
    }
    if (!handleForcesEnabled) {
      return super.onVelocityUpdate(dt, velocity);
    }
    final oldVelocity = velocity.clone();
    final mergeForces = <Force2D>[..._forces, ...gameRef.globalForces];
    final acceleration = mergeForces.whereType<AccelerationForce2D>();
    final resistence = mergeForces.whereType<ResistanceForce2D>();
    final linear = mergeForces.whereType<LinearForce2D>();

    var newVel = onApplyAccelerationForces(acceleration, velocity, dt);
    newVel = onApplyLinearForces(linear, newVel, dt);
    newVel = onApplyResistenceForces(resistence, newVel, dt);

    return (oldVelocity + newVel) * 0.5;
  }

  Vector2 onApplyAccelerationForces(
    Iterable<Force2D> forces,
    Vector2 velocity,
    double dt,
  ) {
    return forces.fold<Vector2>(
      velocity,
      (p, e) => e.transform(p, mass, dt),
    );
  }

  Vector2 onApplyResistenceForces(
    Iterable<Force2D> forces,
    Vector2 velocity,
    double dt,
  ) {
    return forces.fold<Vector2>(
      velocity,
      (p, e) => e.transform(p, mass, dt),
    );
  }

  Vector2 onApplyLinearForces(
    Iterable<Force2D> forces,
    Vector2 velocity,
    double dt,
  ) {
    return forces.fold<Vector2>(
      velocity,
      (p, e) => e.transform(p, mass, dt),
    );
  }
}
