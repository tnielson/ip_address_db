namespace :db do
  desc "Deletes all ActiveRecords in KNSH and the KNSH itself"
  task(:delete_knsh => :environment) do
    knsh = Ipnet.find_by_name("KNSH")
    #Ipnet.destroy_all(["parent_id = ?"], knsh.id)
    Ipnet.delete_all "parent_id = #{knsh.id}"
    knsh.destroy
  end #task
end #namespace