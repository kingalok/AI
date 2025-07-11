✅ Phase 1: Unblock SHIR Upgrade via GitLab EVA Token Issue

Goal: Fix the EVA token issue in GitLab pipeline for upgraded SHIR deployment.

Steps:
	•	✅ Tested UAMI with Upgraded SHIR (Status: Done)
	•	🔄 EVA Token Fetch Fails in Pipeline
→ Old JWT method deprecated.
→ New direct fetch method implemented, but still failing.
	•	🛠️ Ongoing:
→ Follow-up ticket open with EVA team
→ EVA Clinic call on Tuesday for live debugging.

Next Actions:
	•	Prepare pipeline logs + token fetch code for clinic session.
	•	Document fallback strategy if clinic doesn’t resolve the issue.

⸻

⚙️ Phase 2: Define and Deploy Our ADF Infrastructure via ADO

Goal: Shift from POC GitLab infra to full ADO-managed ADF infra.

Current State:
	•	ADF instance deployed via ADO pipeline.
	•	SHIR not yet deployed.
	•	Supporting components missing: Batch Account, Key Vault, Storage, etc.

Next Actions:
	1.	Design full infra ARM/Bicep/Terraform templates.
	2.	Add SHIR deployment logic using updated method.
	3.	Define naming conventions and RBAC assignments for:
	•	UAMI
	•	Key Vault access policies
	•	SHIR registration keys
	•	Batch account integration

⸻

🧪 Phase 3: Infra Prep for UAMI Script Activity Testing

Goal: Set up all pre-reqs to test UAMI-based script activity in ADF.

Checklist:
	•	UAMI created and assigned correct roles (Contributor + DB access)
	•	SHIR linked to ADF + supports UAMI auth
	•	SQL/PGSQL target DB configured with MI auth enabled
	•	Test pipeline YAML and SQL script in place

⸻

🔁 Phase 4: Migrate Build Pipelines to New Infra

Goal: Migrate workloads from old ADF to new one.

AC5 Build Pipeline:
	•	Point to new ADF instance
	•	Test connection and trigger flow
	•	Validate UAMI auth and access to required resources

RoleSync Build Pipeline:
	•	Same steps as above
	•	Ensure all dependencies (e.g., ADF datasets, linked services) are ported
