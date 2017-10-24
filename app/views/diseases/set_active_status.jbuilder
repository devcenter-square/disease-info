json.disease do
  json.id @disease.id
  json.name @disease.name
  json.data_updated_at @disease.date_updated
  json.facts @disease.facts
  json.symptoms @disease.symptoms
  json.transmission @disease.transmission
  json.diagnosis @disease.diagnosis
  json.treatment @disease.treatment
  json.prevention @disease.prevention
  json.more @disease.more
  json.is_active @disease.is_active
end
