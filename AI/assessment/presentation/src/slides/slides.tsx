import type { SlideComponent } from "./engine";

import { DatasetSlide } from "./slides/DatasetSlide";
import { EDASlide } from "./slides/EDASlide";
import { EvaluationSlide } from "./slides/EvaluationSlide";
import { ImbalanceHandlingSlide } from "./slides/ImbalanceHandlingSlide";
import { MethodologySlide } from "./slides/MethodologySlide";
import { ProblemStatementSlide } from "./slides/ProblemStatementSlide";
import { ResearchQuestionSlide } from "./slides/ResearchQuestionSlide";
import { SubmissionSlide } from "./slides/SubmissionSlide";
import { ThankYouSlide } from "./slides/ThankYouSlide";
import { TitleSlide } from "./slides/TitleSlide";

export const slides: SlideComponent[] = [
	TitleSlide,
	ProblemStatementSlide,
	ResearchQuestionSlide,
	DatasetSlide,
	EDASlide,
	MethodologySlide,
	ImbalanceHandlingSlide,
	SubmissionSlide,
	EvaluationSlide,
	ThankYouSlide,
];
