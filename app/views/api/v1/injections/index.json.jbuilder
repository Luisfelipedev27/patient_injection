json.injections @injections do |injection|
  json.id injection.id
  json.dose injection.dose
  json.lot_number injection.lot_number
  json.drug_name injection.drug_name
  json.injected_at injection.injected_at
end
