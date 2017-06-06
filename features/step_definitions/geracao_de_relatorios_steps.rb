Given(/^o sistema possui o departamento de "([^"]*)" cadastrado$/) do |dep_name|
  dep = create_department({department: {name: dep_name}})
  expect(dep).to_not be nil
end

Given(/^o sistema possui o laboratório de "([^"]*)" cadastrado no departamento de "([^"]*)"$/) do |lab_name, dep_name|
  dep = Department.find_by(name: dep_name)
  expect(dep).to_not be nil
  lab = create_laboratory({laboratory: {name: lab_name, department_id: dep.id}})
 end 

Given(/^o sistema possui "([^"]*)"kg de resíduos cadastrados no laboratório de "([^"]*)"$/) do |res_weight, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = create_residue({residue:{name: "Acido", laboratory_id: lab.id}})
  expect(res).to_not be nil
  create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
  reg = modify_date_last_register(res.id, "23/02/2017")
  expect(reg).to_not be nil
  expect(res.total_res).to eq(res_weight.to_f())
  end

When(/^eu tento produzir o relatório total de resíduos cadastrados entre as datas "([^"]*)" e "([^"]*)" para o departamento de "([^"]*)"$/) do |data_begin, data_final, dep_name|
 
  dep = (Department.find_by(name: dep_name))
  expect(dep).to_not be nil
  value_total = 0
  Laboratory.where(department_id: dep.id).each do |it|
      p it.total_lab  
      value_total = value_total + it.total_lab.to_f()
  end
  p value_total
  
  end

Then(/^o valor retornado pelo sistema será "([^"]*)"kg$/) do |res_weight|
  expect(@value_test).to eq(res_weight.to_f())
end

Given(/^o sistema possui "([^"]*)" kg de resíduos cadastrados entre entre as datas "([^"]*)" e "([^"]*)" para o laboratorio de "([^"]*)"$/) do |res_weight, data_begin, data_final, lab_name|
  lab = Laboratory.find_by(name: lab_name)
	expect(lab).to_not be nil
	res = Residue.find_by(name:"Acido", laboratory_id: lab.id)
	if(res != nil) then
	  reg = {register: {weight: res_weight.to_f(), residue_id: res.id}}
  else
    res = create_residue({residue: {name:"Acido", laboratory_id: lab.id}})
    modify_date_last_register(res_id,data_begin.to_date)
    put_date(res,data_begin.to_date)
    reg = {register: {weight: res_weight.to_f(), residue_id: res.id}}
  end
	expect(res).to_not be nil
	post '/update_weight', reg

	modify_date_last_register(res_id,data_begin.to_date)
	res = Residue.where(laboratory_id: lab.id)
  expect(res).to_not be nil
	sum_registers(res,data_begin,data_final)
  expect(@value_test).to eq(res_weight.to_f())
  p res.total.eql?(res_weight)

end

Given(/^o sistema possui o departamento de "([^"]*)" cadastrado com o resíduo "([^"]*)" com quantidade total de "([^"]*)"Kg$/) do |dep_name, res_name, res_total|
  dep = create_department({department: {name: dep_name}})
  expect(dep).to_not be nil
  lab = create_laboratory({laboratory: {name: "lab_base: " + dep_name, department_id: dep.id}})
  expect(lab).to_not be nil
  res = create_residue({residue: {name: res_name, laboratory_id: lab.id}})
  expect(res).to_not be nil
  reg = create_register({register: {weight: res_total.to_f(), residue_id: res.id}})
  expect(reg.weight).to eq(res_total.to_f())
end

When(/^eu tento gerar um relatório dos resíduos dos departamentos de "([^"]*)", "([^"]*)" e "([^"]*)"$/) do |dep1, dep2, dep3|
  rep = {report: {
    generate_by: 1, 
    begin_dt: "01/01/2001".to_date, 
    end_dt: "29/12/2029".to_date, 
    unit: false, 
    state: false, 
    kind: false, 
    onu: false, 
    blend: false, 
    code: false, 
    total: true,
    list: [dep1, dep2, dep3]}
  }
  post '/reports', rep
end

Then(/^o sistema retorna o valor de "([^"]*)"Kg para o resíduo "([^"]*)"$/) do |res_weight, res_name|
  repc = Reportcell.where(res_name: res_name)
  total = 0
  repc.each do |it|
    total += it.total
  end
  expect(total).to eq(res_weight.to_f())
end

Given(/^o resíduo "([^"]*)" possui tipo como "([^"]*)", peso como "([^"]*)"Kg e código ONU como "([^"]*)" no laboratorio de "([^"]*)"$/) do |res_name, res_kind, res_weight, res_onu, lab_name|
  lab = Laboratory.find_by(name: lab_name)
  expect(lab).to_not be nil
  res = create_residue({residue: {name: res_name, kind: res_kind, onu: res_onu, laboratory_id: lab.id}})
  expect(res).to_not be nil
  reg = create_register({register: {weight: res_weight.to_f(), residue_id: res.id}})
  expect(reg.weight).to eq(res_weight.to_f())
end

When(/^eu tento produzir um relatório dos resíduos do laboratório de "([^"]*)", com os filtros tipo e peso\.$/) do |res|
  rep = {report: {
    generate_by: 2, 
    begin_dt: "01/01/2001".to_date, 
    end_dt: "29/12/2029".to_date, 
    unit: false, 
    state: false, 
    kind: true, 
    onu: false, 
    blend: false, 
    code: false, 
    total: true,
    list: [res]}
  }
  post '/reports', rep
end

Then(/^o sistema retorna as informações "([^"]*)" e "([^"]*)"Kg para o resíduo "([^"]*)"$/) do |kind, quant, res_name|
  repc = Reportcell.where(res_name: res_name)
  total = 0
  repc.each do |it|
    total += it.total
  end
  expect(total).to eq(quant.to_f())
  expect(repc[0].kind).to eq (kind)
end

def create_department(dep)
  post '/departments', dep
  Department.find_by(name: dep[:department][:name])
end

def create_laboratory(lab)
  post '/laboratories', lab
  Laboratory.find_by(name: lab[:laboratory][:name], department_id: lab[:laboratory][:department_id])
end

def create_residue(res)
  post '/residues', res
  Residue.find_by(name: res[:residue][:name], laboratory_id: res[:residue][:laboratory_id])
end

def create_register(reg)
  post '/registers', reg
  Residue.find(reg[:register][:residue_id]).registers.last
end

def modify_date_last_register(res_id, date)
  reg = Residue.find(res_id).registers.last
  reg.created_at = date.to_date
  reg.save
  reg
end

