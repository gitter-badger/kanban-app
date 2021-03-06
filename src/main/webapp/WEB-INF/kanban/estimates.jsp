<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>

<head>
	<title>Project Estimation Tool for Kanban</title>
	
	<jsp:include page="include/header-head.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/estimates.js?version=${service.version}"></script>
	
</head>

<body class="main">
 	<jsp:include page="include/header.jsp"/> 
	
	<h1>Project Estimation Tool for Kanban</h1>

 	<form action="pet-set-project-property"> 
		<table class="pet">
			<tr>
				<td>Budget</td>
				<td>$${estimatesproject.budget}</td>
				<td>
					<input id="projectPropertyNameHiddenField" type="hidden" name="name" value="" /> 
					<input id="projectPropertyValueHiddenField" type="hidden" name="value" value="" /> 
					<input type="submit" value="Edit" onclick="return changeProjectProperty('budget', 'budget', '${estimatesproject.budget}');" />
				</td>
			</tr>
			<tr>
				<td>Cost so far <img src="${pageContext.request.contextPath}/images/question.png" title="Please update this field regularly" /></td>
				<td>$${estimatesproject.costSoFar}</td>
				<td><a href="#" id="edit-cost-so-far">Edit</a></td>
			</tr>
			<tr>
				<td>Cost per point (estimated) <img src="${pageContext.request.contextPath}/images/question.png" title="Compare this value with 'Cost per point so far'" /></td>
				<td>$${estimatesproject.estimatedCostPerPoint}</td>
				<td>
					<input type="submit" value="Edit" onclick="return changeProjectProperty('estimated cost per point', 'estimatedCostPerPoint', '${estimatesproject.estimatedCostPerPoint}');" />
				</td>
			</tr>
			<tr>
				<td>Cost per point so far <img src="${pageContext.request.contextPath}/images/question.png" title="This value is based on Complete features and 'Cost so far'" /></td>
				<td>$${estimatesproject.costPerPointSoFar}</td>
				<td>
				</td>
			</tr>
		</table>
	</form>

	<h2>Planned features</h2>

	<table id="plannedFeatures" class="pet">
		<tr>
			<th rowspan="2" colspan="2">Actions</th>
			<th rowspan="2">Description</th>
			<th rowspan="2">Importance</th>
			<th colspan="2">Feature points</th>
			<th colspan="2">Running estimate</th>
		</tr>
		<tr>
			<th>Average Case <img src="${pageContext.request.contextPath}/images/question.png" title="50 % chances that cost will be lower than that value" /></th>
			<th>Worst Case <img src="${pageContext.request.contextPath}/images/question.png" title="90 % chances that cost will be lower than that value" /></th>
			<th>Average Case</th>
			<th>Worst Case <img src="${pageContext.request.contextPath}/images/question.png" title="Yes, this is not a simple sum of worst cases for features" /></th>
		</tr>
		<c:forEach items="${estimatesproject.budgetEntries}" var="entry" varStatus="status">
		
			
			<c:choose>
				<c:when test="${entry.feature.mustHave}">
					<c:set var="tagClass" value="${entry.overBudgetInAverageCase ? 'mustHaveOverAverage' : (entry.overBudgetInWorstCase ? 'mustHaveOverWorst' : 'mustHaveOk')}" scope="page" />
				</c:when>
				<c:otherwise>
					<c:set var="tagClass" value="${entry.overBudgetInAverageCase ? 'niceHaveOver' : 'niceHaveOk' }" scope="page" />
				</c:otherwise>
			</c:choose>
			<tr class="${tagClass}">
				<td>
					<table class="nolines">
						<tr>
							<td colspan="2">
								<form action="pet-set-feature-included-in-estimates">
									<div>
										<input type="hidden" name="id" value="${entry.feature.id}" />

										<input type="hidden" name="value" value="${entry.feature.mustHave ? 'false' : 'true'}" /> 

										<input id="must-have-${status.count}" type="submit" value="${entry.feature.mustHave ? 'Nice to Have' : 'Must Have'}" />
									</div>
								</form>
							</td>
						</tr>
						<tr>
							<td>
								<form action="pet-edit-feature">
									<div>
										<input type="hidden" name="id" value="${entry.feature.id}" />
										<input type="submit" value="Edit Est." />
									</div>
								</form>
							</td>
						</tr>
					</table>
				</td>
				<td>
					<form action="pet-move-feature">
						<div>
							<input type="hidden" name="id" value="${entry.feature.id}" /> 
							<input type="hidden" name="direction" value="up" /> 

							<c:choose>
								<c:when test="${entry.prevFeature == null}">
									<input type="submit" value="↑" disabled="disabled"/>
								</c:when>
								<c:otherwise>
									<input type="hidden" name="targetId" value="${entry.prevFeature.id}" />
									<input type="submit" value="↑"/>
								</c:otherwise>
							</c:choose>
						</div>
					</form>
					<form action="pet-move-feature">
						<div>
							<input type="hidden" name="id" value="${entry.feature.id}" /> 
							<input type="hidden" name="direction" value="down" /> 
							
							<c:choose>
								<c:when test="${entry.nextFeature == null}">
									<input type="submit" value="↓" disabled="disabled"/>
								</c:when>
								<c:otherwise>
									<input type="hidden" name="targetId" value="${entry.nextFeature.id}" />
									<input type="submit" value="↓" />
								</c:otherwise>
							</c:choose>
						</div>
					</form>
				</td>
				<td class="${tagClass}">${entry.feature.name}</td>
				<td><i>${entry.feature.mustHave ? 'Must have' : 'Nice to have'}</i></td>
				<td>${entry.feature.averageCaseEstimate}</td>
				<td>${entry.feature.worstCaseEstimate}</td>
				<td class="${tagClass}">$${entry.averageCaseCumulativeCost}</td>
				<td class="${tagClass}">$${entry.worstCaseCumulativeCost}</td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="2" />
			<td colspan="6">
				<span style="color: #777777">To add more features go to project wall</span>
			</td>
		</tr>
	</table>
	
	<h3>Legend</h3>
	<table class="pet">
		<tr class="mustHaveOk"><td>'Must have' features</td></tr>
		<tr class="mustHaveOverWorst"><td>'Must have' features over the budget (Worst Case)</td></tr>
		<tr class="niceHaveOk"><td>'Nice to have' features</td></tr>
		<tr class="niceHaveOver"><td>'Nice to have' features over the budget (Average Case)</td></tr>
	</table>

	<h2>Complete features</h2>

	<table class="pet">
		<tr>
			<th>Description</th>
			<th>Feature points <img src="${pageContext.request.contextPath}/images/question.png" title="This field shows 'Average Case' estimate for the feature" /></th>
		</tr>
		<c:forEach items="${estimatesproject.completedFeatures}" var="feature">
			<c:set var="tagClass" value="${feature.mustHave ? 'mustHaveOk' : 'niceHaveOk' }" scope="page" />

			<tr class="${tagClass}">
				<td>${feature.name}</td>
				<td>${feature.averageCaseEstimate}</td>
			</tr>
		</c:forEach>
	</table>

	<p>Cost per point so far: $${estimatesproject.costPerPointSoFar}</p>
    
    
    <div id="edit-cost-so-far-dialog" style="display: none;" title="Project cost">
        <table id="cost_table">
            <tr>
                <td>Day</td><td>Cost:</td>
            </tr>
            <c:forEach var="item" items="${estimatesproject.dayCosts}" varStatus="daysCount">
                <tr>
                    <td><input type="text" id="date_${daysCount.count}" value="${item.key}"   size="10"/></td>
                    <td><input type="text" id="cost_${daysCount.count}" value="${item.value}" size="10"/></td>
                </tr>
            </c:forEach>
        </table>
        <button id="add_costs">Add entry</button>
    </div>
</body>

</html>
