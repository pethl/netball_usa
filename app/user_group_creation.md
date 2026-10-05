# User Group Creation / Recovery Notes

This file documents important `UserGroup` records that may need to be recreated if local/reference data is reset or overwritten.

## University Admin Team

The USA University section expects a user group with the following key:

```text
university_admin_team
```

The University Admin Team page uses this key to find the group:

```ruby
UserGroup.find_by!(key: "university_admin_team")
```

If the group does not exist, visiting the University Admin Team page will result in:

```text
ActiveRecord::RecordNotFound
Couldn't find UserGroup with [WHERE "user_groups"."key" = $1]
```

### Recreate the group

Open the Rails console:

```bash
bin/rails console
```

Then run:

```ruby
university_group = UserGroup.find_or_create_by!(
  key: "university_admin_team"
) do |group|
  group.name = "University Admin Team"
  group.description = "Users who manage USA University objectives and tasks"
  group.active = true
end
```

Verify the group exists:

```ruby
UserGroup.find_by(key: "university_admin_team")
```

## Important: Group Memberships

Recreating the `UserGroup` does NOT necessarily recreate the users assigned to it.

The University Admin Team was originally intended to include the following people:

- Lynnette@NetballAmerica.com
- Erin@NetballAmerica.com
- Kate@NetballAmerica.com
- DrJayned@aol.com

If local data has been reset or overwritten, check the group's memberships after recreating the group.

For example:

```ruby
university_group.users
```

or:

```ruby
university_group.users.pluck(:id, :email)
```

If the group exists but the University Admin Team page is empty, the group memberships are likely what need restoring.

## Key Details

```text
Key:         university_admin_team
Name:        University Admin Team
Description: Users who manage USA University objectives and tasks
Active:      true
```

**Do not change the key without also updating code/routes that reference `university_admin_team`.**