# egy_tracker — High-Speed Codebase & Symbol Index
*Generated automatically in 326.9ms for Gemini 3.8 Flash High.*

> [!TIP]
> **Surgical Navigation**: Check this index or use `python3 scripts/find_symbol.py <symbol>` to pinpoint file and line numbers without reading entire files.

## Summary Metrics
- **Total Dart Files**: 195
- **Total Dart Lines**: 16508
- **Indexed Symbols**: 1753

---

## Core Models
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/core/models/mod_activity_item.dart`](lib/core/models/mod_activity_item.dart) | 32 | ActivityItem | Core Models |
| [`lib/core/models/mod_allowed_email.dart`](lib/core/models/mod_allowed_email.dart) | 30 | AllowedEmail | Core Models |
| [`lib/core/models/mod_borrow.dart`](lib/core/models/mod_borrow.dart) | 69 | Borrow | Core Models |
| [`lib/core/models/mod_exchange.dart`](lib/core/models/mod_exchange.dart) | 55 | Exchange | Core Models |
| [`lib/core/models/mod_expense.dart`](lib/core/models/mod_expense.dart) | 62 | Expense | Core Models |
| [`lib/core/models/mod_initial_balance.dart`](lib/core/models/mod_initial_balance.dart) | 34 | InitialBalance | Core Models |
| [`lib/core/models/mod_user_profile.dart`](lib/core/models/mod_user_profile.dart) | 38 | UserProfile | Core Models |

## Core Services
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/core/services/f_auth.dart`](lib/core/services/f_auth.dart) | 82 | AuthService | Core Services |
| [`lib/core/services/f_auth_dev_user.dart`](lib/core/services/f_auth_dev_user.dart) | 87 | DevUser | Core Services |
| [`lib/core/services/f_auth_google.dart`](lib/core/services/f_auth_google.dart) | 39 | GoogleAuthHelper | Core Services |
| [`lib/core/services/f_auth_operations.dart`](lib/core/services/f_auth_operations.dart) | 54 | AuthOperations | Core Services |
| [`lib/core/services/f_auth_sync.dart`](lib/core/services/f_auth_sync.dart) | 36 | - | Core Services |
| [`lib/core/services/f_firestore.dart`](lib/core/services/f_firestore.dart) | 67 | FirestoreServiceBase, FirestoreService | Core Services |
| [`lib/core/services/f_firestore_emails.dart`](lib/core/services/f_firestore_emails.dart) | 72 | FirestoreEmailsMixin | Core Services |
| [`lib/core/services/f_firestore_expenses.dart`](lib/core/services/f_firestore_expenses.dart) | 41 | FirestoreExpensesMixin | Core Services |
| [`lib/core/services/f_firestore_purge.dart`](lib/core/services/f_firestore_purge.dart) | 96 | FirestorePurgeMixin | Core Services |
| [`lib/core/services/f_firestore_transfers.dart`](lib/core/services/f_firestore_transfers.dart) | 77 | FirestoreTransfersMixin | Core Services |
| [`lib/core/services/f_firestore_users_balances.dart`](lib/core/services/f_firestore_users_balances.dart) | 49 | FirestoreUsersBalancesMixin | Core Services |

## Core Utilities & Math
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/core/utils/m_auth_helpers.dart`](lib/core/utils/m_auth_helpers.dart) | 62 | resolveUserPhoto, resolveUserName | Core Utilities & Math |
| [`lib/core/utils/m_calculations.dart`](lib/core/utils/m_calculations.dart) | 74 | Calculations | Core Utilities & Math |
| [`lib/core/utils/m_calculations_balances.dart`](lib/core/utils/m_calculations_balances.dart) | 88 | matchesUser | Core Utilities & Math |
| [`lib/core/utils/m_calculations_shares.dart`](lib/core/utils/m_calculations_shares.dart) | 44 | - | Core Utilities & Math |
| [`lib/core/utils/m_formatters.dart`](lib/core/utils/m_formatters.dart) | 83 | Formatters | Core Utilities & Math |
| [`lib/core/utils/m_validators.dart`](lib/core/utils/m_validators.dart) | 85 | Validators | Core Utilities & Math |

## Feature: Home Tab
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/features/home/components/c_home_action_handler.dart`](lib/features/home/components/c_home_action_handler.dart) | 77 | HomeActionHandler | Feature: Home Tab |
| [`lib/features/home/components/c_home_activities_list.dart`](lib/features/home/components/c_home_activities_list.dart) | 126 | HomeActivitiesList, _ActivityListSkeleton | Feature: Home Tab |
| [`lib/features/home/components/c_home_balances_card.dart`](lib/features/home/components/c_home_balances_card.dart) | 66 | HomeBalancesCard | Feature: Home Tab |
| [`lib/features/home/components/c_home_nav_bar.dart`](lib/features/home/components/c_home_nav_bar.dart) | 58 | HomeNavBar | Feature: Home Tab |
| [`lib/features/home/components/c_home_tab_actions.dart`](lib/features/home/components/c_home_tab_actions.dart) | 85 | HomeTabActions | Feature: Home Tab |
| [`lib/features/home/components/c_home_tab_stack.dart`](lib/features/home/components/c_home_tab_stack.dart) | 52 | HomeTabStack | Feature: Home Tab |
| [`lib/features/home/feed/vm_home_feed_activity_builder.dart`](lib/features/home/feed/vm_home_feed_activity_builder.dart) | 76 | HomeFeedActivityBuilder | Feature: Home Tab |
| [`lib/features/home/feed/vm_home_feed_balance_calculator.dart`](lib/features/home/feed/vm_home_feed_balance_calculator.dart) | 88 | HomeBalancesResult, HomeFeedBalanceCalculator | Feature: Home Tab |
| [`lib/features/home/feed/vm_home_feed_filter.dart`](lib/features/home/feed/vm_home_feed_filter.dart) | 6 | HomeFeedFilter | Feature: Home Tab |
| [`lib/features/home/feed/vm_home_feed_mutations.dart`](lib/features/home/feed/vm_home_feed_mutations.dart) | 48 | HomeFeedMutations, HomeFeedMutationsMixin | Feature: Home Tab |
| [`lib/features/home/feed/vm_home_feed_profiles.dart`](lib/features/home/feed/vm_home_feed_profiles.dart) | 63 | HomeFeedProfiles | Feature: Home Tab |
| [`lib/features/home/feed/vm_home_feed_state.dart`](lib/features/home/feed/vm_home_feed_state.dart) | 77 | HomeFeedState | Feature: Home Tab |
| [`lib/features/home/models/mod_activity_item.dart`](lib/features/home/models/mod_activity_item.dart) | 1 | - | Feature: Home Tab |
| [`lib/features/home/s_home.dart`](lib/features/home/s_home.dart) | 100 | HomeScreen, _HomeScreenState | Feature: Home Tab |
| [`lib/features/home/s_home_tab.dart`](lib/features/home/s_home_tab.dart) | 119 | HomeTabScreen | Feature: Home Tab |
| [`lib/features/home/vm_home.dart`](lib/features/home/vm_home.dart) | 24 | HomeViewModel | Feature: Home Tab |
| [`lib/features/home/vm_home_feed.dart`](lib/features/home/vm_home_feed.dart) | 117 | HomeFeedViewModel | Feature: Home Tab |

## Feature: My Tracker Tab
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/features/my_tracker/components/c_my_tracker_actions.dart`](lib/features/my_tracker/components/c_my_tracker_actions.dart) | 50 | MyTrackerActions | Feature: My Tracker Tab |
| [`lib/features/my_tracker/components/c_my_tracker_list.dart`](lib/features/my_tracker/components/c_my_tracker_list.dart) | 93 | MyTrackerExpenseList | Feature: My Tracker Tab |
| [`lib/features/my_tracker/s_my_tracker.dart`](lib/features/my_tracker/s_my_tracker.dart) | 94 | MyTrackerScreen, _MyTrackerScreenState | Feature: My Tracker Tab |
| [`lib/features/my_tracker/tracker/vm_my_tracker_calculator.dart`](lib/features/my_tracker/tracker/vm_my_tracker_calculator.dart) | 99 | MyTrackerCalculator | Feature: My Tracker Tab |
| [`lib/features/my_tracker/tracker/vm_my_tracker_filter.dart`](lib/features/my_tracker/tracker/vm_my_tracker_filter.dart) | 7 | MyTrackerFilter | Feature: My Tracker Tab |
| [`lib/features/my_tracker/tracker/vm_my_tracker_getters.dart`](lib/features/my_tracker/tracker/vm_my_tracker_getters.dart) | 99 | MyTrackerGettersMixin | Feature: My Tracker Tab |
| [`lib/features/my_tracker/tracker/vm_my_tracker_mutations.dart`](lib/features/my_tracker/tracker/vm_my_tracker_mutations.dart) | 80 | MyTrackerMutationsMixin | Feature: My Tracker Tab |
| [`lib/features/my_tracker/tracker/vm_my_tracker_profiles.dart`](lib/features/my_tracker/tracker/vm_my_tracker_profiles.dart) | 66 | MyTrackerProfiles | Feature: My Tracker Tab |
| [`lib/features/my_tracker/tracker/vm_my_tracker_state.dart`](lib/features/my_tracker/tracker/vm_my_tracker_state.dart) | 53 | MyTrackerState | Feature: My Tracker Tab |
| [`lib/features/my_tracker/tracker/vm_my_tracker_subscriptions.dart`](lib/features/my_tracker/tracker/vm_my_tracker_subscriptions.dart) | 44 | MyTrackerSubscriptions | Feature: My Tracker Tab |
| [`lib/features/my_tracker/vm_my_tracker.dart`](lib/features/my_tracker/vm_my_tracker.dart) | 53 | MyTrackerViewModel | Feature: My Tracker Tab |

## Feature: Settings Tab
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/features/settings/components/c_add_email_dialog.dart`](lib/features/settings/components/c_add_email_dialog.dart) | 78 | - | Feature: Settings Tab |
| [`lib/features/settings/components/c_add_email_form.dart`](lib/features/settings/components/c_add_email_form.dart) | 65 | AddEmailForm | Feature: Settings Tab |
| [`lib/features/settings/components/c_allowed_email_tile.dart`](lib/features/settings/components/c_allowed_email_tile.dart) | 71 | AllowedEmailTile | Feature: Settings Tab |
| [`lib/features/settings/components/c_allowed_email_tile_content.dart`](lib/features/settings/components/c_allowed_email_tile_content.dart) | 101 | AllowedEmailTileContent | Feature: Settings Tab |
| [`lib/features/settings/components/c_allowed_email_tile_info.dart`](lib/features/settings/components/c_allowed_email_tile_info.dart) | 61 | AllowedEmailTileInfo | Feature: Settings Tab |
| [`lib/features/settings/components/c_allowed_emails_card.dart`](lib/features/settings/components/c_allowed_emails_card.dart) | 106 | AllowedEmailsCard | Feature: Settings Tab |
| [`lib/features/settings/components/c_allowed_emails_list.dart`](lib/features/settings/components/c_allowed_emails_list.dart) | 80 | AllowedEmailsList | Feature: Settings Tab |
| [`lib/features/settings/components/c_balance_edit_button.dart`](lib/features/settings/components/c_balance_edit_button.dart) | 33 | BalanceEditButton | Feature: Settings Tab |
| [`lib/features/settings/components/c_balance_user_card.dart`](lib/features/settings/components/c_balance_user_card.dart) | 82 | BalanceUserCard | Feature: Settings Tab |
| [`lib/features/settings/components/c_balance_user_header.dart`](lib/features/settings/components/c_balance_user_header.dart) | 93 | BalanceUserHeader | Feature: Settings Tab |
| [`lib/features/settings/components/c_confirm_delete_email_dialog.dart`](lib/features/settings/components/c_confirm_delete_email_dialog.dart) | 56 | - | Feature: Settings Tab |
| [`lib/features/settings/components/c_delete_data_action_runner.dart`](lib/features/settings/components/c_delete_data_action_runner.dart) | 69 | DeleteDataActionRunner | Feature: Settings Tab |
| [`lib/features/settings/components/c_delete_data_card.dart`](lib/features/settings/components/c_delete_data_card.dart) | 53 | DeleteDataCard | Feature: Settings Tab |
| [`lib/features/settings/components/c_delete_data_checkbox_list.dart`](lib/features/settings/components/c_delete_data_checkbox_list.dart) | 92 | DeleteDataCheckboxList | Feature: Settings Tab |
| [`lib/features/settings/components/c_delete_data_checkbox_row.dart`](lib/features/settings/components/c_delete_data_checkbox_row.dart) | 60 | DeleteDataCheckboxRow | Feature: Settings Tab |
| [`lib/features/settings/components/c_delete_data_content.dart`](lib/features/settings/components/c_delete_data_content.dart) | 78 | DeleteDataContent | Feature: Settings Tab |
| [`lib/features/settings/components/c_delete_data_dialog.dart`](lib/features/settings/components/c_delete_data_dialog.dart) | 64 | - | Feature: Settings Tab |
| [`lib/features/settings/components/c_delete_data_selection.dart`](lib/features/settings/components/c_delete_data_selection.dart) | 31 | DeleteDataSelection | Feature: Settings Tab |
| [`lib/features/settings/components/c_edit_initial_balances_dialog.dart`](lib/features/settings/components/c_edit_initial_balances_dialog.dart) | 95 | - | Feature: Settings Tab |
| [`lib/features/settings/components/c_edit_initial_balances_form.dart`](lib/features/settings/components/c_edit_initial_balances_form.dart) | 63 | EditInitialBalancesForm | Feature: Settings Tab |
| [`lib/features/settings/components/c_friend_balance_item.dart`](lib/features/settings/components/c_friend_balance_item.dart) | 73 | FriendBalanceItem | Feature: Settings Tab |
| [`lib/features/settings/components/c_initial_balance_input_field.dart`](lib/features/settings/components/c_initial_balance_input_field.dart) | 73 | InitialBalanceInputField | Feature: Settings Tab |
| [`lib/features/settings/components/c_initial_balances_card.dart`](lib/features/settings/components/c_initial_balances_card.dart) | 131 | InitialBalancesCard, _InitialBalancesCardState | Feature: Settings Tab |
| [`lib/features/settings/components/c_initial_balances_resolver.dart`](lib/features/settings/components/c_initial_balances_resolver.dart) | 98 | InitialBalancesData | Feature: Settings Tab |
| [`lib/features/settings/components/c_profile_card.dart`](lib/features/settings/components/c_profile_card.dart) | 99 | ProfileCard | Feature: Settings Tab |
| [`lib/features/settings/components/c_profile_info.dart`](lib/features/settings/components/c_profile_info.dart) | 55 | ProfileInfoColumn | Feature: Settings Tab |
| [`lib/features/settings/components/c_settings_animations.dart`](lib/features/settings/components/c_settings_animations.dart) | 41 | SettingsAnimations | Feature: Settings Tab |
| [`lib/features/settings/components/c_settings_profile_section.dart`](lib/features/settings/components/c_settings_profile_section.dart) | 43 | SettingsProfileSection | Feature: Settings Tab |
| [`lib/features/settings/components/c_theme_option_card.dart`](lib/features/settings/components/c_theme_option_card.dart) | 99 | ThemeOptionCard | Feature: Settings Tab |
| [`lib/features/settings/components/c_theme_selector_card.dart`](lib/features/settings/components/c_theme_selector_card.dart) | 50 | ThemeSelectorCard | Feature: Settings Tab |
| [`lib/features/settings/s_settings.dart`](lib/features/settings/s_settings.dart) | 104 | SettingsScreen, _SettingsScreenState | Feature: Settings Tab |
| [`lib/features/settings/vm_settings.dart`](lib/features/settings/vm_settings.dart) | 99 | SettingsViewModel | Feature: Settings Tab |

## Feature: Auth
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/features/auth/components/c_access_denied_screen.dart`](lib/features/auth/components/c_access_denied_screen.dart) | 81 | AccessDeniedScreen | Feature: Auth |
| [`lib/features/auth/components/c_auth_whitelist_gate.dart`](lib/features/auth/components/c_auth_whitelist_gate.dart) | 113 | AuthWhitelistGate, _AuthWhitelistGateState | Feature: Auth |
| [`lib/features/auth/components/c_google_sign_in_button.dart`](lib/features/auth/components/c_google_sign_in_button.dart) | 65 | GoogleSignInButton | Feature: Auth |
| [`lib/features/auth/components/c_login_form.dart`](lib/features/auth/components/c_login_form.dart) | 50 | LoginForm | Feature: Auth |
| [`lib/features/auth/components/c_login_logo_button.dart`](lib/features/auth/components/c_login_logo_button.dart) | 54 | LoginLogoButton | Feature: Auth |
| [`lib/features/auth/s_auth_gate.dart`](lib/features/auth/s_auth_gate.dart) | 68 | AuthGate, _AuthGateState | Feature: Auth |
| [`lib/features/auth/s_login.dart`](lib/features/auth/s_login.dart) | 67 | LoginScreen, _LoginScreenState | Feature: Auth |
| [`lib/features/auth/vm_auth.dart`](lib/features/auth/vm_auth.dart) | 64 | AuthViewModel | Feature: Auth |

## Core UI Components
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/core/components/activity_tiles/c_activity_amount.dart`](lib/core/components/activity_tiles/c_activity_amount.dart) | 49 | - | Core UI Components |
| [`lib/core/components/activity_tiles/c_activity_borrow_tile.dart`](lib/core/components/activity_tiles/c_activity_borrow_tile.dart) | 103 | - | Core UI Components |
| [`lib/core/components/activity_tiles/c_activity_exchange_tile.dart`](lib/core/components/activity_tiles/c_activity_exchange_tile.dart) | 86 | - | Core UI Components |
| [`lib/core/components/activity_tiles/c_activity_expense_tile.dart`](lib/core/components/activity_tiles/c_activity_expense_tile.dart) | 114 | - | Core UI Components |
| [`lib/core/components/balance/c_balance_card_decoration.dart`](lib/core/components/balance/c_balance_card_decoration.dart) | 37 | - | Core UI Components |
| [`lib/core/components/balance/c_balance_currency_section.dart`](lib/core/components/balance/c_balance_currency_section.dart) | 77 | - | Core UI Components |
| [`lib/core/components/balance/c_empty_traveler_card.dart`](lib/core/components/balance/c_empty_traveler_card.dart) | 72 | EmptyTravelerCard | Core UI Components |
| [`lib/core/components/balance/c_traveler_identity_bar.dart`](lib/core/components/balance/c_traveler_identity_bar.dart) | 71 | - | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_amount_inputs.dart`](lib/core/components/borrow_dialog/c_borrow_amount_inputs.dart) | 104 | BorrowAmountInputs | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_date_picker.dart`](lib/core/components/borrow_dialog/c_borrow_date_picker.dart) | 79 | BorrowDatePicker | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_dialog_content.dart`](lib/core/components/borrow_dialog/c_borrow_dialog_content.dart) | 81 | BorrowDialogContent | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_dialog_models.dart`](lib/core/components/borrow_dialog/c_borrow_dialog_models.dart) | 79 | BorrowLimits | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_dialog_params.dart`](lib/core/components/borrow_dialog/c_borrow_dialog_params.dart) | 35 | BorrowDialogParams | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_dialog_view.dart`](lib/core/components/borrow_dialog/c_borrow_dialog_view.dart) | 101 | BorrowDialogView, _BorrowDialogViewState | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_direction_chip.dart`](lib/core/components/borrow_dialog/c_borrow_direction_chip.dart) | 89 | BorrowDirectionChip | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_direction_selector.dart`](lib/core/components/borrow_dialog/c_borrow_direction_selector.dart) | 99 | BorrowDirectionSelector | Core UI Components |
| [`lib/core/components/borrow_dialog/c_borrow_submit_handler.dart`](lib/core/components/borrow_dialog/c_borrow_submit_handler.dart) | 63 | BorrowSubmitHandler | Core UI Components |
| [`lib/core/components/c_action_icon_button.dart`](lib/core/components/c_action_icon_button.dart) | 77 | ActionIconButton | Core UI Components |
| [`lib/core/components/c_action_sheet_item.dart`](lib/core/components/c_action_sheet_item.dart) | 67 | ActionSheetTile | Core UI Components |
| [`lib/core/components/c_activity_tile.dart`](lib/core/components/c_activity_tile.dart) | 106 | ActivityTile | Core UI Components |
| [`lib/core/components/c_add_action_sheet.dart`](lib/core/components/c_add_action_sheet.dart) | 72 | - | Core UI Components |
| [`lib/core/components/c_add_exchange_dialog.dart`](lib/core/components/c_add_exchange_dialog.dart) | 104 | - | Core UI Components |
| [`lib/core/components/c_add_expense_dialog.dart`](lib/core/components/c_add_expense_dialog.dart) | 69 | - | Core UI Components |
| [`lib/core/components/c_alert_banner.dart`](lib/core/components/c_alert_banner.dart) | 84 | AlertSeverity, AlertBanner | Core UI Components |
| [`lib/core/components/c_app_dialog.dart`](lib/core/components/c_app_dialog.dart) | 90 | AppDialog | Core UI Components |
| [`lib/core/components/c_badge.dart`](lib/core/components/c_badge.dart) | 53 | StatusBadge | Core UI Components |
| [`lib/core/components/c_borrow_dialog.dart`](lib/core/components/c_borrow_dialog.dart) | 70 | - | Core UI Components |
| [`lib/core/components/c_confirmation_dialog.dart`](lib/core/components/c_confirmation_dialog.dart) | 92 | ConfirmationDialog | Core UI Components |
| [`lib/core/components/c_currency_pill.dart`](lib/core/components/c_currency_pill.dart) | 63 | CurrencyPill | Core UI Components |
| [`lib/core/components/c_danger_button.dart`](lib/core/components/c_danger_button.dart) | 57 | DangerButton | Core UI Components |
| [`lib/core/components/c_delete_activity_dialog.dart`](lib/core/components/c_delete_activity_dialog.dart) | 43 | - | Core UI Components |
| [`lib/core/components/c_dialog_actions.dart`](lib/core/components/c_dialog_actions.dart) | 84 | AppDialogActions | Core UI Components |
| [`lib/core/components/c_dialog_header.dart`](lib/core/components/c_dialog_header.dart) | 64 | AppDialogHeader | Core UI Components |
| [`lib/core/components/c_empty_state.dart`](lib/core/components/c_empty_state.dart) | 85 | EmptyState, _EmptyStateState | Core UI Components |
| [`lib/core/components/c_empty_state_content.dart`](lib/core/components/c_empty_state_content.dart) | 59 | EmptyStateContent | Core UI Components |
| [`lib/core/components/c_empty_state_icon.dart`](lib/core/components/c_empty_state_icon.dart) | 36 | EmptyStateIcon | Core UI Components |
| [`lib/core/components/c_floating_pill_nav_bar.dart`](lib/core/components/c_floating_pill_nav_bar.dart) | 83 | FloatingPillNavBar | Core UI Components |
| [`lib/core/components/c_icon_badge.dart`](lib/core/components/c_icon_badge.dart) | 52 | IconBadge | Core UI Components |
| [`lib/core/components/c_section_card.dart`](lib/core/components/c_section_card.dart) | 40 | SectionCard | Core UI Components |
| [`lib/core/components/c_section_card_body.dart`](lib/core/components/c_section_card_body.dart) | 33 | SectionCardBody | Core UI Components |
| [`lib/core/components/c_section_card_decoration.dart`](lib/core/components/c_section_card_decoration.dart) | 31 | - | Core UI Components |
| [`lib/core/components/c_section_card_header.dart`](lib/core/components/c_section_card_header.dart) | 85 | SectionCardHeader | Core UI Components |
| [`lib/core/components/c_section_card_state.dart`](lib/core/components/c_section_card_state.dart) | 89 | _SectionCardState | Core UI Components |
| [`lib/core/components/c_segmented_pill_bar.dart`](lib/core/components/c_segmented_pill_bar.dart) | 96 | SegmentedPillItem, SegmentedPillBar | Core UI Components |
| [`lib/core/components/c_segmented_pill_tile.dart`](lib/core/components/c_segmented_pill_tile.dart) | 90 | SegmentedPillTile | Core UI Components |
| [`lib/core/components/c_show_confirmation_dialog.dart`](lib/core/components/c_show_confirmation_dialog.dart) | 69 | - | Core UI Components |
| [`lib/core/components/c_slide_action_button.dart`](lib/core/components/c_slide_action_button.dart) | 78 | - | Core UI Components |
| [`lib/core/components/c_slide_action_card.dart`](lib/core/components/c_slide_action_card.dart) | 34 | SlideActionCard | Core UI Components |
| [`lib/core/components/c_slide_action_card_state.dart`](lib/core/components/c_slide_action_card_state.dart) | 96 | _SlideActionCardState | Core UI Components |
| [`lib/core/components/c_slide_action_item.dart`](lib/core/components/c_slide_action_item.dart) | 22 | SlideActionItem | Core UI Components |
| [`lib/core/components/c_slide_action_row.dart`](lib/core/components/c_slide_action_row.dart) | 43 | - | Core UI Components |
| [`lib/core/components/c_traveler_balance_card.dart`](lib/core/components/c_traveler_balance_card.dart) | 102 | TravelerBalanceCard | Core UI Components |
| [`lib/core/components/c_user_avatar.dart`](lib/core/components/c_user_avatar.dart) | 68 | UserAvatar | Core UI Components |
| [`lib/core/components/exchange_dialog/c_exchange_amount_inputs.dart`](lib/core/components/exchange_dialog/c_exchange_amount_inputs.dart) | 88 | ExchangeAmountInputs | Core UI Components |
| [`lib/core/components/exchange_dialog/c_exchange_date_picker.dart`](lib/core/components/exchange_dialog/c_exchange_date_picker.dart) | 83 | ExchangeDatePicker | Core UI Components |
| [`lib/core/components/exchange_dialog/c_exchange_dialog_content.dart`](lib/core/components/exchange_dialog/c_exchange_dialog_content.dart) | 69 | ExchangeDialogContent | Core UI Components |
| [`lib/core/components/exchange_dialog/c_exchange_direction_chip.dart`](lib/core/components/exchange_dialog/c_exchange_direction_chip.dart) | 42 | - | Core UI Components |
| [`lib/core/components/exchange_dialog/c_exchange_direction_selector.dart`](lib/core/components/exchange_dialog/c_exchange_direction_selector.dart) | 41 | ExchangeDirectionSelector | Core UI Components |
| [`lib/core/components/exchange_dialog/c_exchange_save_action.dart`](lib/core/components/exchange_dialog/c_exchange_save_action.dart) | 54 | ExchangeSaveButton | Core UI Components |
| [`lib/core/components/exchange_dialog/c_exchange_submit_handler.dart`](lib/core/components/exchange_dialog/c_exchange_submit_handler.dart) | 65 | ExchangeSubmitHandler | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_body.dart`](lib/core/components/expense_dialog/c_expense_dialog_body.dart) | 111 | ExpenseDialogBody | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_custom_slider.dart`](lib/core/components/expense_dialog/c_expense_dialog_custom_slider.dart) | 65 | ExpenseCustomSplitSlider | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_date.dart`](lib/core/components/expense_dialog/c_expense_dialog_date.dart) | 89 | ExpenseDatePicker | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_fields.dart`](lib/core/components/expense_dialog/c_expense_dialog_fields.dart) | 106 | ExpenseDialogFields | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_models.dart`](lib/core/components/expense_dialog/c_expense_dialog_models.dart) | 98 | ExpenseDialogBalances, ExpenseDialogSplitState, ExpenseDialogParams | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_payer.dart`](lib/core/components/expense_dialog/c_expense_dialog_payer.dart) | 55 | ExpensePayerSelector | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_save_action.dart`](lib/core/components/expense_dialog/c_expense_dialog_save_action.dart) | 54 | ExpenseSaveButton | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_split.dart`](lib/core/components/expense_dialog/c_expense_dialog_split.dart) | 82 | ExpenseSplitSelector | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_submit.dart`](lib/core/components/expense_dialog/c_expense_dialog_submit.dart) | 86 | ExpenseSubmitHandler | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_validation.dart`](lib/core/components/expense_dialog/c_expense_dialog_validation.dart) | 36 | ExpenseSplitCalculator | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_view.dart`](lib/core/components/expense_dialog/c_expense_dialog_view.dart) | 101 | ExpenseDialogView, _ExpenseDialogViewState | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_warning.dart`](lib/core/components/expense_dialog/c_expense_dialog_warning.dart) | 76 | ExpenseCashWarning | Core UI Components |
| [`lib/core/components/expense_dialog/c_expense_dialog_widgets.dart`](lib/core/components/expense_dialog/c_expense_dialog_widgets.dart) | 73 | - | Core UI Components |
| [`lib/core/components/nav/c_animated_zoom_button.dart`](lib/core/components/nav/c_animated_zoom_button.dart) | 99 | AnimatedZoomButton, _AnimatedZoomButtonState | Core UI Components |
| [`lib/core/components/nav/c_floating_nav_item.dart`](lib/core/components/nav/c_floating_nav_item.dart) | 14 | FloatingNavItem | Core UI Components |
| [`lib/core/components/nav/c_nav_add_button.dart`](lib/core/components/nav/c_nav_add_button.dart) | 60 | - | Core UI Components |
| [`lib/core/components/nav/c_nav_center_pill.dart`](lib/core/components/nav/c_nav_center_pill.dart) | 53 | - | Core UI Components |
| [`lib/core/components/nav/c_nav_exchange_button.dart`](lib/core/components/nav/c_nav_exchange_button.dart) | 60 | - | Core UI Components |
| [`lib/core/components/nav/c_nav_tab_item.dart`](lib/core/components/nav/c_nav_tab_item.dart) | 95 | - | Core UI Components |

## Core Animations
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/core/animations/a_dialog_transition.dart`](lib/core/animations/a_dialog_transition.dart) | 71 | DialogLifecycleWrapper, _DialogLifecycleWrapperState | Core Animations |
| [`lib/core/animations/a_fade_slide_transition.dart`](lib/core/animations/a_fade_slide_transition.dart) | 33 | FadeSlideTransition | Core Animations |
| [`lib/core/animations/a_press_scale.dart`](lib/core/animations/a_press_scale.dart) | 56 | PressScale, _PressScaleState | Core Animations |
| [`lib/core/animations/a_shimmer.dart`](lib/core/animations/a_shimmer.dart) | 86 | Shimmer, _ShimmerState, _SlidingGradientTransform | Core Animations |
| [`lib/core/animations/a_staggered_item.dart`](lib/core/animations/a_staggered_item.dart) | 86 | StaggeredItem, _StaggeredItemState | Core Animations |

## Theme
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/core/theme/t_app_theme.dart`](lib/core/theme/t_app_theme.dart) | 109 | AppTheme | Theme |
| [`lib/core/theme/t_button_input_themes.dart`](lib/core/theme/t_button_input_themes.dart) | 80 | buildFilledButtonTheme | Theme |
| [`lib/core/theme/t_palette.dart`](lib/core/theme/t_palette.dart) | 97 | - | Theme |
| [`lib/core/theme/t_surface_themes.dart`](lib/core/theme/t_surface_themes.dart) | 85 | - | Theme |

## Root / Config
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`lib/core/config/app_config.dart`](lib/core/config/app_config.dart) | 20 | AppConfig | Root / Config |
| [`lib/core/config/feature_flags.dart`](lib/core/config/feature_flags.dart) | 9 | FeatureFlags | Root / Config |
| [`lib/firebase_options.dart`](lib/firebase_options.dart) | 68 | DefaultFirebaseOptions | Root / Config |
| [`lib/main.dart`](lib/main.dart) | 58 | MyApp, main | Root / Config |

## Tests
| File | Lines | Key Classes / Functions | Primary Purpose |
| :--- | :---: | :--- | :--- |
| [`test/dialogs_and_animations_test.dart`](test/dialogs_and_animations_test.dart) | 819 | main, group, group | Tests |
| [`test/home_feed_test.dart`](test/home_feed_test.dart) | 743 | MockFirestoreService, main, group, test | Tests |
| [`test/home_navigation_test.dart`](test/home_navigation_test.dart) | 202 | FakeAuthService, FakeFirestoreService, main, group, setUp | Tests |
| [`test/login_screen_test.dart`](test/login_screen_test.dart) | 110 | FakeAuthService, main, group, setUp | Tests |
| [`test/models_test.dart`](test/models_test.dart) | 105 | main, group, test | Tests |
| [`test/my_tracker_test.dart`](test/my_tracker_test.dart) | 447 | FakeFirestoreService, main, group, setUp | Tests |
| [`test/settings_screen_test.dart`](test/settings_screen_test.dart) | 512 | FakeAuthService, FakeFirestoreService, main, group, setUp | Tests |
| [`test/slide_action_card_test.dart`](test/slide_action_card_test.dart) | 198 | main, group, testWidgets | Tests |
| [`test/theme_and_ui_test.dart`](test/theme_and_ui_test.dart) | 73 | main, group, test | Tests |
| [`test/utils_test.dart`](test/utils_test.dart) | 389 | main, group, test | Tests |
| [`test/widget_test.dart`](test/widget_test.dart) | 37 | _FakeAuthService, _FakeFirestoreService, main, testWidgets | Tests |
