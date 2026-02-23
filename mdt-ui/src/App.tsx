import React from "react";
import { useTranslation } from "react-i18next";
import CitizenSearch from "./components/CitizenSearch";
import CitationForm from "./components/CitationForm";
import AuditLog from "./components/AuditLog";
import ArrestReport from "./components/ArrestReport";
import WarrantSheet from "./components/WarrantSheet";
import EvidencePanel from "./components/EvidencePanel";

function App() {
  const { t } = useTranslation();

  return (
    <div className="min-h-screen" style={{ background: "var(--parchment-dark, #A88D68)", fontFamily: "var(--font-body, 'Courier Prime', 'Courier New', monospace)" }}>
      <header style={{ background: "var(--sepia-dark, #24160A)", borderBottom: "2px solid var(--sepia, #3E2712)", padding: "12px 24px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <h1 style={{ fontFamily: "var(--font-heading, 'Cinzel', 'Times New Roman', serif)", color: "var(--gold-light, #D4A85A)", fontSize: "1.25rem", letterSpacing: "0.12em", textTransform: "uppercase" }}>{t("mdt_title")}</h1>
      </header>
      <main className="p-6 grid grid-cols-2 gap-6" style={{ background: "var(--parchment, #C8AA82)" }}>
        <CitizenSearch />
        <CitationForm />
        <ArrestReport />
        <WarrantSheet />
        <EvidencePanel />
        <AuditLog />
      </main>
    </div>
  );
}

export default App;