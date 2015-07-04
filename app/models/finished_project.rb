class FinishedProject < Project
  default_scope { where(finished: true) }

  rails_admin do
    label "Projects"

    list do
      field :title, :string
      field :authors, :string
      field :category_name, :string
      field :county, :string
      field :approved
    end

    create do
      field :title, :string
      field :description, :string
      field :technical_description, :string
      field :system_requirements, :string
      field :source_url, :string
      field :homepage, :string

      field :approved, :boolean

      field :category do
        nested_form false
      end

      field :contestants do
        nested_form false
      end
    end

    edit do
      field :title, :string
      field :description, :string
      field :technical_description, :string
      field :system_requirements, :string
      field :source_url, :string
      field :homepage, :string

      field :approved, :boolean

      field :category do
        nested_form false
      end

      field :contestants do
        nested_form false
      end
    end

  end

end