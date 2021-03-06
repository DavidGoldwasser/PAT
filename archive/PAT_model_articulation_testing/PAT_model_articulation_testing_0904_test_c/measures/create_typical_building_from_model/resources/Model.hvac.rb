class OpenStudio::Model::Model
  # Adds the HVAC system as derived from the combinations of
  # CBECS 2012 MAINHT and MAINCL fields.
  # Mapping between combinations and HVAC systems per
  # http://www.nrel.gov/docs/fy08osti/41956.pdf
  # Table C-31
  def add_cbecs_hvac_system(standard, system_type, zones)

    # the 'zones' argument includes zones that have heating, cooling, or both
    # if the HVAC system type serves a single zone, handle zones with only heating separately by adding unit heaters
    # applies to system types PTAC, PTHP, PSZ-AC, and Window AC
    heated_and_cooled_zones = zones.select { |zone| standard.thermal_zone_heated?(zone) && standard.thermal_zone_cooled?(zone)}
    heated_zones = zones.select { |zone| standard.thermal_zone_heated?(zone)}
    cooled_zones = zones.select { |zone| standard.thermal_zone_cooled?(zone)}
    cooled_only_zones = zones.select { |zone| !standard.thermal_zone_heated?(zone) && standard.thermal_zone_cooled?(zone)}
    heated_only_zones = zones.select { |zone| standard.thermal_zone_heated?(zone) && !standard.thermal_zone_cooled?(zone)}
    system_zones = heated_and_cooled_zones + cooled_only_zones

    case system_type
    when 'PTAC with hot water heat'
      standard.model_add_hvac_system(self, 'PTAC', ht = 'NaturalGas', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard hot water heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'NaturalGas', znht = nil, cl = nil, heated_only_zones)

    when 'PTAC with hot water heat with central air source heat pump'
      standard.model_add_hvac_system(self, 'PTAC', ht = 'AirSourceHeatPump', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard hot water heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'AirSourceHeatPump', znht = nil, cl = nil, heated_only_zones)

    when 'PTAC with gas coil heat'
      standard.model_add_hvac_system(self, 'PTAC', ht = nil, znht = 'NaturalGas', cl = 'Electricity', system_zones)
      # use 'Baseboard electric heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_only_zones)

    when 'PTAC with electric baseboard heat'
      standard.model_add_hvac_system(self, 'PTAC', ht = nil, znht = nil, cl = 'Electricity', system_zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)

    when 'PTAC with no heat'
      standard.model_add_hvac_system(self, 'PTAC', ht = nil, znht = nil, cl = 'Electricity', system_zones)

    when 'PTAC with district hot water heat'
      standard.model_add_hvac_system(self, 'PTAC', ht = 'DistrictHeating', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard district hot water heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'DistrictHeating', znht = nil, cl = nil, heated_only_zones)

    when 'PTAC with central air source heat pump heat'
      standard.model_add_hvac_system(self, 'PTAC', ht = 'AirSourceHeatPump', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard district hot water heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'AirSourceHeatPump', znht = nil, cl = nil, heated_only_zones)

    when 'PTHP'
      standard.model_add_hvac_system(self, 'PTHP', ht = 'Electricity', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard electric heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_only_zones)

    when 'PSZ-AC with gas coil heat'
      standard.model_add_hvac_system(self, 'PSZ-AC', ht = 'NaturalGas', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard electric heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_only_zones)

    when 'PSZ-AC with electric baseboard heat'
      standard.model_add_hvac_system(self, 'PSZ-AC', ht = nil, znht = nil, cl = 'Electricity', system_zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)

    when 'PSZ-AC with no heat'
      standard.model_add_hvac_system(self, 'PSZ-AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'PSZ-AC with district hot water heat'
      standard.model_add_hvac_system(self, 'PSZ-AC', ht = 'DistrictHeating', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard district hot water heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'DistrictHeating', znht = nil, cl = nil, heated_only_zones)

    when 'PSZ-AC with central air source heat pump heat'
      standard.model_add_hvac_system(self, 'PSZ-AC', ht = 'AirSourceHeatPump', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard district hot water heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'AirSourceHeatPump', znht = nil, cl = nil, heated_only_zones)

    when 'PSZ-HP'
      standard.model_add_hvac_system(self, 'PSZ-HP', ht = 'Electricity', znht = nil, cl = 'Electricity', system_zones)
      # use 'Baseboard electric heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_only_zones)

    when 'Fan coil district chilled water with no heat'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = nil, znht = nil, cl = 'DistrictCooling', zones)

    when 'Fan coil district chilled water and boiler'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'NaturalGas', znht = nil, cl = 'DistrictCooling', zones)

    when 'Fan coil district chilled water and central air source heat pump'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'AirSourceHeatPump', znht = nil, cl = 'DistrictCooling', zones)

    when 'Fan coil district chilled water unit heaters'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = nil, znht = nil, cl = 'DistrictCooling', zones)
      standard.model_add_hvac_system(self, 'Unit Heaters', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Fan coil district chilled water electric baseboard heat'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = nil, znht = nil, cl = 'DistrictCooling', zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)

    when 'Fan coil district hot and chilled water'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'DistrictHeating', znht = nil, cl = 'DistrictCooling', zones)

    when 'Fan coil district hot water and chiller'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'DistrictHeating', znht = nil, cl = 'Electricity', zones)

    when 'Fan coil district hot water and air-cooled chiller'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'DistrictHeating', znht = nil, cl = 'Electricity', zones,
                                     chilled_water_loop_cooling_type: 'AirCooled')

    when 'Fan coil chiller with no heat'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = nil, znht = nil, cl = 'Electricity', zones)

    when 'Fan coil chiller and boiler'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'NaturalGas', znht = nil, cl = 'Electricity', zones)

    when 'Fan coil air-cooled chiller and boiler'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'NaturalGas', znht = nil, cl = 'Electricity', zones,
                                     chilled_water_loop_cooling_type: 'AirCooled')

    when 'Fan coil chiller and central air source heat pump'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'AirSourceHeatPump', znht = nil, cl = 'Electricity', zones)

    when 'Fan coil air-cooled chiller and central air source heat pump'
      standard.model_add_hvac_system(self, 'Fan Coil', ht = 'AirSourceHeatPump', znht = nil, cl = 'Electricity', zones,
                                     chilled_water_loop_cooling_type: 'AirCooled')

    when 'DOAS with fan coil district chilled water with no heat'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = nil, znht = nil, cl = 'DistrictCooling', zones)

    when 'DOAS with fan coil district chilled water and boiler'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'NaturalGas', znht = nil, cl = 'DistrictCooling', zones)

    when 'DOAS with fan coil district chilled water and central air source heat pump'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'AirSourceHeatPump', znht = nil, cl = 'DistrictCooling', zones)

    when 'DOAS with fan coil district chilled water unit heaters'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = nil, znht = nil, cl = 'DistrictCooling', zones)
      standard.model_add_hvac_system(self, 'Unit Heaters', ht = 'NaturalGas', znht = nil, cl = nil, zones)

    when 'DOAS with fan coil district chilled water electric baseboard heat'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = nil, znht = nil, cl = 'DistrictCooling', zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, zones)

    when 'DOAS with fan coil district hot and chilled water'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'DistrictHeating', znht = nil, cl = 'DistrictCooling', zones)

    when 'DOAS with fan coil district hot water and chiller'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'DistrictHeating', znht = nil, cl = 'Electricity', zones)

    when 'DOAS with fan coil district hot water and air-cooled chiller'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'DistrictHeating', znht = nil, cl = 'Electricity', zones,
                                     chilled_water_loop_cooling_type: 'AirCooled')

    when 'DOAS with fan coil chiller and boiler'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'NaturalGas', znht = nil, cl = 'Electricity', zones)

    when 'DOAS with fan coil air-cooled chiller and boiler'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'NaturalGas', znht = nil, cl = 'Electricity', zones,
                                     chilled_water_loop_cooling_type: 'AirCooled')

    when 'DOAS with fan coil chiller and central air source heat pump'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'AirSourceHeatPump', znht = nil, cl = 'Electricity', zones)

    when 'DOAS with fan coil air-cooled chiller and central air source heat pump'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = 'AirSourceHeatPump', znht = nil, cl = 'Electricity', zones,
                                     chilled_water_loop_cooling_type: 'AirCooled')

    when 'DOAS with fan coil chiller with no heat'
      standard.model_add_hvac_system(self, 'Fan Coil with DOAS', ht = nil, znht = nil, cl = 'Electricity', zones)

    when 'VRF with DOAS'
      standard.model_add_hvac_system(self, 'VRF with DOAS', 'Electricity', 'nil', 'Electricity', zones)

    when 'Ground Source Heat Pumps with DOAS'
      standard.model_add_hvac_system(self, 'Ground Source Heat Pumps with DOAS', 'Electricity', nil, 'Electricity', zones,
                                     air_loop_heating_type: 'DX',
                                     air_loop_cooling_type: 'DX')

    when 'Baseboard district hot water heat'
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'DistrictHeating', znht = nil, cl = nil, heated_zones)

    when 'Baseboard district hot water heat with direct evap coolers'
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'DistrictHeating', znht = nil, cl = nil, heated_zones)
      standard.model_add_hvac_system(self, 'Evaporative Cooler', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Baseboard electric heat'
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)

    when 'Baseboard electric heat with direct evap coolers'
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)
      standard.model_add_hvac_system(self, 'Evaporative Cooler', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Baseboard hot water heat'
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Baseboard hot water heat with direct evap coolers'
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)
      standard.model_add_hvac_system(self, 'Evaporative Cooler', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Window AC with no heat'
      standard.model_add_hvac_system(self, 'Window AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Window AC with forced air furnace'
      standard.model_add_hvac_system(self, 'Window AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      standard.model_add_hvac_system(self, 'Forced Air Furnace', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Window AC with district hot water baseboard heat'
      standard.model_add_hvac_system(self, 'Window AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'DistrictHeating', znht = nil, cl = nil, heated_zones)

    when 'Window AC with hot water baseboard heat'
      standard.model_add_hvac_system(self, 'Window AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Window AC with electric baseboard heat'
      standard.model_add_hvac_system(self, 'Window AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)

    when 'Window AC with unit heaters'
      standard.model_add_hvac_system(self, 'Window AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      standard.model_add_hvac_system(self, 'Unit Heaters', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Direct evap coolers'
      standard.model_add_hvac_system(self, 'Evaporative Cooler', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Direct evap coolers with unit heaters'
      standard.model_add_hvac_system(self, 'Unit Heaters', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)
      standard.model_add_hvac_system(self, 'Evaporative Cooler', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Unit heaters'
      standard.model_add_hvac_system(self, 'Unit Heaters', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Heat pump heat with no cooling'
      standard.model_add_hvac_system(self, 'Residential Air Source Heat Pump', ht = nil, znht = nil, cl = 'Electricity', heated_zones)

    when 'Heat pump heat with direct evap cooler'
      standard.model_add_hvac_system(self, 'Evaporative Cooler', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      # standard.model_add_hvac_system(self, 'Residential Air Source Heat Pump', ht=nil, znht=nil, cl='Electricity', zones)
      # Using PTHP to represent zone heat pump for this configuration
      # because only one airloop may be connected to each thermal zone.
      standard.model_add_hvac_system(self, 'PTHP', ht = 'Electricity', znht = nil, cl = 'Electricity', system_zones)
      # disable the cooling coils in all the PTHPs
      getZoneHVACPackagedTerminalHeatPumps.each do |pthp|
        clg_coil = pthp.heatingCoil.to_CoilHeatingDXSingleSpeed.get
        clg_coil.setAvailabilitySchedule(alwaysOffDiscreteSchedule)
      end
      # use 'Baseboard electric heat' for heated only zones
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_only_zones)

    when 'VAV with reheat'
      standard.model_add_hvac_system(self, 'VAV Reheat', ht = 'NaturalGas', znht = 'NaturalGas', cl = 'Electricity', zones)

    when 'VAV with reheat central air source heat pump'
      standard.model_add_hvac_system(self, 'VAV Reheat', ht = 'AirSourceHeatPump', znht = 'AirSourceHeatPump', cl = 'Electricity', zones)

    when 'VAV with PFP boxes'
      standard.model_add_hvac_system(self, 'VAV PFP Boxes', ht = 'NaturalGas', znht = 'NaturalGas', cl = 'Electricity', zones)

    when 'VAV with gas reheat'
      standard.model_add_hvac_system(self, 'VAV Gas Reheat', ht = 'NaturalGas', ht = 'NaturalGas', cl = 'Electricity', zones)

    when 'VAV with zone unit heaters'
      standard.model_add_hvac_system(self, 'VAV No Reheat', ht = 'NaturalGas', znht = nil, cl = 'Electricity', zones)
      standard.model_add_hvac_system(self, 'Unit Heaters', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'VAV with electric baseboard heat'
      standard.model_add_hvac_system(self, 'VAV No Reheat', ht = 'NaturalGas', znht = nil, cl = 'Electricity', zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)

    when 'VAV cool with zone heat pump heat'
      standard.model_add_hvac_system(self, 'VAV No Reheat', ht = 'NaturalGas', znht = nil, cl = 'Electricity', zones)
      # standard.model_add_hvac_system(self, 'Residential Air Source Heat Pump', ht=nil, znht=nil, cl='Electricity', zones)
      # Using PTHP to represent zone heat pump for this configuration
      # because only one airloop may be connected to each thermal zone.
      standard.model_add_hvac_system(self, 'PTHP', ht = 'Electricity', znht = nil, cl = 'Electricity', zones)
      # disable the cooling coils in all the PTHPs
      getZoneHVACPackagedTerminalHeatPumps.each do |pthp|
        clg_coil = pthp.heatingCoil.to_CoilHeatingDXSingleSpeed.get
        clg_coil.setAvailabilitySchedule(alwaysOffDiscreteSchedule)
      end

    when 'PVAV with reheat', 'Packaged VAV Air Loop with Boiler' # second enumeration for backwards compatibility with Tenant Star project
      standard.model_add_hvac_system(self, 'PVAV Reheat', ht = 'NaturalGas', znht = 'NaturalGas', cl = 'Electricity', zones)

    when 'PVAV with reheat with central air source heat pump'
      standard.model_add_hvac_system(self, 'PVAV Reheat', ht = 'AirSourceHeatPump', znht = 'AirSourceHeatPump', cl = 'Electricity', zones)

    when 'PVAV with PFP boxes'
      standard.model_add_hvac_system(self, 'PVAV PFP Boxes', ht = 'Electricity', znht = 'Electricity', cl = 'Electricity', zones)

    when 'Residential forced air'
      standard.model_add_hvac_system(self, 'Residential Forced Air Furnace', ht = 'NaturalGas', znht = nil, cl = nil, zones)

    when 'Residential forced air cooling hot water baseboard heat'
      standard.model_add_hvac_system(self, 'Residential AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Residential forced air with district hot water'
      standard.model_add_hvac_system(self, 'Residential AC', ht = nil, znht = nil, cl = 'Electricity', zones)

    when 'Residential heat pump'
      standard.model_add_hvac_system(self, 'Residential Air Source Heat Pump', ht = 'Electricity', znht = nil, cl = 'Electricity', zones)

    when 'Forced air furnace'
      standard.model_add_hvac_system(self, 'Forced Air Furnace', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)

    when 'Forced air furnace district chilled water fan coil'
      standard.model_add_hvac_system(self, 'Forced Air Furnace', ht = 'NaturalGas', znht = nil, cl = nil, zones)
      standard.model_add_hvac_system(self, 'Fan Coil', ht = nil, znht = nil, cl = 'DistrictCooling', zones)

    when 'Forced air furnace direct evap cooler'
      # standard.model_add_hvac_system(self, 'Forced Air Furnace', ht='NaturalGas', znht=nil, cl=nil, zones)
      # Using unit heater to represent forced air furnace for this configuration
      # because only one airloop may be connected to each thermal zone.
      standard.model_add_hvac_system(self, 'Unit Heaters', ht = 'NaturalGas', znht = nil, cl = nil, heated_zones)
      standard.model_add_hvac_system(self, 'Evaporative Cooler', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Residential AC with no heat'
      standard.model_add_hvac_system(self, 'Residential AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)

    when 'Residential AC with electric baseboard heat'
      standard.model_add_hvac_system(self, 'Residential AC', ht = nil, znht = nil, cl = 'Electricity', cooled_zones)
      standard.model_add_hvac_system(self, 'Baseboards', ht = 'Electricity', znht = nil, cl = nil, heated_zones)

    else
      puts "HVAC system type '#{system_type}' not recognized"

    end
  end
end
