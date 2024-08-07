class Case < ApplicationRecord
  include PublicActivity::Model
  belongs_to :caseworker

  has_many :case_caseworkers
  accepts_nested_attributes_for :case_caseworkers, allow_destroy: true

  has_many :caseworkers, through: :case_caseworkers
  accepts_nested_attributes_for :caseworkers, allow_destroy: true

  has_many :members, -> { order(:id) }, dependent: :destroy
  accepts_nested_attributes_for :members, allow_destroy: true

  has_many_attached :files

  # validate :has_one_lead_member

  def self.strong_params
    [
      tags: []
    ]
  end

  def member_name
    lead_member.try(:full_name)
  end

  def lead_member
    members.find(&:lead_case_member) || members.try(:first)
  end

  def member_nationality
    members.try(:first).try(:nationality)
  end

  def self.unrelated_caseworkers(case_id)
    if the_case = Case.find_by(id: case_id)
      Caseworker.all.reject { |caseworker| caseworker.id == the_case.caseworker_id || the_case.caseworkers.include?(caseworker) }
    else
      Caseworker.all
    end
  end

  def rename_file(file, new_name)
    file.blob.update!(filename: new_name)
  end

  # overwriting the setter to add new files, without deleting the existing
  def files=(attachables)
    attachables = Array(attachables).compact_blank

    if attachables.any?
      attachment_changes["files"] =
        ActiveStorage::Attached::Changes::CreateMany.new("files", self, files.blobs + attachables)
    end
  end

  def self.tag_options
    [
      "Health",
      "Legal",
      "Clothes",
      "Food",
      "Other"
    ]
  end

  # def has_one_lead_member
  #   if members.where(lead_case_member: true).count > 1
  #     errors.add(:lead_case_member, "can't have more than one lead case member")
  #   end
  # end
end
