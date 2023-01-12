within FRP.RTUVAV.Component;
model VAVReHeat_withCtrl_TRooCon
  "This model includes VAV damper controller. Heater controlls room air temperature."
   replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
   parameter Modelica.SIunits.MassFlowRate m_flow_nominal=m_flow_nominal;
   parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal=Q_flow_nominal;
   parameter Modelica.SIunits.PressureDifference dp_nominal=dp_nominal;

  Buildings.Fluid.Actuators.Dampers.VAVBoxExponential vavDam(
    redeclare package Medium =Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{16,-32},{72,46}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u
                                          ReHeat(
    redeclare package Medium =Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    tau=300,
    Q_flow_nominal=Q_flow_nominal)
    annotation (Placement(transformation(extent={{-68,-24},{-18,36}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-4},{110,16}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-150,-4},{-130,16}})));
  Modelica.Blocks.Interfaces.RealInput TRooHeaSet
    "Room air heating temperature set point" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-126,110})));
  Modelica.Blocks.Interfaces.RealInput TRoo "room air temperature"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-52,114})));
  Modelica.Blocks.Interfaces.RealInput TRooCooSet
    "zone air temperature cooling setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,112})));
  Buildings.Controls.Continuous.LimPID conCoo(
    yMax=1,
    Td=60,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0.1,
    initType=Modelica.Blocks.Types.InitPID.NoInit,
    reverseAction=true)
    "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{14,58},{34,78}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conHea(
    yMax=1,
    initType=Buildings.Controls.OBC.CDL.Types.Init.NoInit,
    xi_start=0,
    Td=60,
    yMin=0,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
            "Controller for heating"
    annotation (Placement(transformation(extent={{-116,56},{-96,76}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort ReheatT(redeclare package Medium
      = Medium, m_flow_nominal=m_flow_nominal) "Temperature after Reheat"
    annotation (Placement(transformation(extent={{-14,-8},{6,22}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort aftervavdamT(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    "Temperature after vavDam"
    annotation (Placement(transformation(extent={{80,-2},{92,18}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort beforeReheatT1(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    "Temperature after Reheat"
    annotation (Placement(transformation(extent={{-108,-4},{-96,16}})));
equation
  connect(TRooCooSet, conCoo.u_s) annotation (Line(points={{0,112},{0,68},{12,
          68}},         color={0,0,127}));
  connect(TRoo, conCoo.u_m) annotation (Line(points={{-52,114},{-52,48},{24,48},
          {24,56}}, color={0,0,127}));
  connect(TRooHeaSet, conHea.u_s) annotation (Line(points={{-126,110},{-126,66},
          {-118,66}}, color={0,0,127}));
  connect(TRoo, conHea.u_m) annotation (Line(points={{-52,114},{-52,48},{-106,
          48},{-106,54}},      color={0,0,127}));
  connect(conHea.y, ReHeat.u) annotation (Line(points={{-95,66},{-90,66},{-90,
          24},{-73,24}},
                     color={0,0,127}));
  connect(conCoo.y, vavDam.y)
    annotation (Line(points={{35,68},{44,68},{44,53.8}}, color={0,0,127}));
  connect(ReHeat.port_b, ReheatT.port_a)
    annotation (Line(points={{-18,6},{-14,6},{-14,7}}, color={0,127,255}));
  connect(ReheatT.port_b, vavDam.port_a)
    annotation (Line(points={{6,7},{16,7}}, color={0,127,255}));
  connect(port_b, aftervavdamT.port_b) annotation (Line(points={{100,6},{96,6},
          {96,8},{92,8}}, color={0,127,255}));
  connect(vavDam.port_b, aftervavdamT.port_a)
    annotation (Line(points={{72,7},{76,7},{76,8},{80,8}}, color={0,127,255}));
  connect(port_a, beforeReheatT1.port_a)
    annotation (Line(points={{-140,6},{-108,6}}, color={0,127,255}));
  connect(beforeReheatT1.port_b, ReHeat.port_a)
    annotation (Line(points={{-96,6},{-68,6}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,100}}),                                  graphics={
          Rectangle(
          extent={{-98,94},{88,-64}},
          lineColor={0,0,0},
          fillColor={75,156,217},
          fillPattern=FillPattern.Solid), Text(
          extent={{-68,46},{58,-18}},
          lineColor={0,0,0},
          fillColor={75,156,217},
          fillPattern=FillPattern.Solid,
          textString="VAVReHeat",
          textStyle={TextStyle.Bold})}),                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,
            100}})));
end VAVReHeat_withCtrl_TRooCon;