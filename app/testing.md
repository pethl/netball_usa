TESTING.md 
# 🧪 Testing Documentation

Your Test → rails_helper.rb → spec_helper.rb → RSpec Core Settings
                ↓
         Rails Environment
         (models, db, config)
                ↓
         Load Capybara, Devise, etc.
                ↓
      Ready to Run Feature + Model Specs

This file keeps track of key tests across the project. Update this file as your test coverage improves.

---
Checklist for Future Rails Test Setups

Save this somewhere easy, like Notion, Apple Notes, etc.
 .rspec has --require rails_helper
 rails_helper.rb requires spec_helper.rb
 rails_helper.rb loads Rails env and support files
 spec/support/database_cleaner.rb is set up correctly
 Database configured for test environment
 Never touch production! (Rails.env.production? safeguard!)=
 --------

## 🏃‍♂️ Core User Flows (Feature Specs)
- [x] User signs up successfully
- [x] User signs in (via other tests)
- [x] User signs out
- [x] User resets password
- [x] User confirms email address
- [ ] User edits profile
- [x] Role based Sign In

---

## 📄 Page Smoke Tests (System Specs)
- [ ] Every main model page loads

---

## 🛠️ CRUD Operations (Feature + System Specs)

NETBALL_EDUCATORS
- [x] Create Educator
- [x] See Validation Errors
- [ ] Read (View) Educator
- [x] Update Educator
- [ ] Delete Educator

------

EQUIPMENT
- [x] Create Equipment
- [x] See Validation Errors
- [ ] Read (View) Equipment
- [x] Update Equipment
- [ ] Delete Equipment

---

MEDIA
- [x] Create Media
- [x] See Validation Errors
- [ ] Read (View) Media
- [x] Update Media
- [ ] Delete Media

---

FOLLOW_UPS
- [x] Create Follow_up
- [x] See Validation Errors
- [ ] Read (View) Follow_up
- [x] Update Follow_up
- [ ] Delete Follow_up

---

## 🔒 Security & Access Control
- [ ] Non-logged-in users are redirected to login
- [ ] Non-admin users cannot access admin pages
- [ ] Deactivated users cannot log in
- [ ] Confirmed email required for login

---

## 🎯 Flash Messages (UI Feedback)
- [x] Flash shows on successful login
- [x] Flash shows on logout
- [ ] Flash shows on password reset
- [ ] Flash shows on unauthorized access
- [ ] Flash shows on profile update

---

## 📦 Model Tests
- [ ] User validations (email, password, etc.)
- [ ] Equipment validations
- [ ] Associations (User has_many Equipment, etc.)

---

## 🔌 Request Specs
- [ ] API returns 200 OK for authenticated user
- [ ] API returns 401 Unauthorized for guest
- [ ] Equipment API create/update/delete tests

---

## 🧹 Other Useful Tests
- [ ] Background jobs (if any) are enqueued properly
- [ ] Email confirmation is sent after signup
- [ ] Password reset email is sent
- [ ] File uploads succeed

---

# 📈 How To Run Tests Locally

```bash
bundle exec rspec
